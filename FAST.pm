package FAST;

use BOSS::Config;
use FAST::LLMClient;
# use MyFRDCSA;

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Config Debug MyLLMClient /

  ];

$UNIVERSAL::debug = 1;

sub init {
  my ($self,%args) = @_;
  $specification = "
	-u [<host> <port>]	Run as a UniLang agent

	-w			Require user input before exiting
";
  # $UNIVERSAL::systemdir = ConcatDir(Dir("internal codebases"),"fast");
  $self->Config(BOSS::Config->new
		(Spec => $specification,
		 ConfFile => ""));
  my $conf = $self->Config->CLIConfig;
  $UNIVERSAL::agent->DoNotDaemonize(1);
  $self->Debug($args{Debug} || 1);
  $self->MyLLMClient
    (FAST::LLMClient->new);
  if (exists $conf->{'-u'}) {
    $UNIVERSAL::agent->Register
      (Host => defined $conf->{-u}->{'<host>'} ?
       $conf->{-u}->{'<host>'} : "localhost",
       Port => defined $conf->{-u}->{'<port>'} ?
       $conf->{-u}->{'<port>'} : "9000");
  }
}

sub Execute {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    # enter in to a listening loop
    while (1) {
      $UNIVERSAL::agent->Listen(TimeOut => 10);
    }
  }
  if (exists $conf->{'-w'}) {
    Message(Message => "Press any key to quit...");
    my $t = <STDIN>;
  }
}

sub ProcessMessage {
  my ($self,%args) = @_;
  my $m = $args{Message};
  my $it = $m->Contents;
  if ($it) {
    if ($it =~ /^echo\s*(.*)/) {
      $UNIVERSAL::agent->SendContents
	(Contents => $1,
	 Receiver => $m->{Sender});
    } elsif ($it =~ /^(quit|exit)$/i) {
      $UNIVERSAL::agent->Deregister;
      exit(0);
    }
  }
  if (exists $m->{Data}) {
    my $d = $m->Data;
    if (defined $d->{GetLLMResponse}) {
      $UNIVERSAL::agent->QueryAgentReply
	(
	 Message => $m,
	 Data => {
		  _DoNotLog => 1,
		  Result => $self->MyLLMClient->GetLLMResponse(%{$d->{GetLLMResponse}}),
		 },
	);
    }
  }
}

1;
