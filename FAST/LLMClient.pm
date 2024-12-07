package FAST::LLMClient;

# see /var/lib/myfrdcsa/codebases/internal/do/scripts/task-processing.pl

use BOSS::Config;
use KBS2::Util;
use LLMs::TemplatingClient;
use Manager::Dialog qw(Choose);
use PerlLib::NLP::Util;
use PerlLib::SwissArmyKnife;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Templates DefaultAction Marker /

  ];

sub init {
  my ($self,%args) = @_;
  $UNIVERSAL::debug = $args{Debug} || (defined $UNIVERSAL::debug ? $UNIVERSAL::debug : 0);
  $self->Templates
    ({
      fastRetort => '/var/lib/myfrdcsa/codebases/minor/prompt-library/data-git/prompts/flp/fast_retort.tt',
     });
  $self->DefaultAction($args{DefaultAction} || 'fastRetort');
  $self->Marker($args{Marker});
}

sub PrintActions {
  my ($self,%args) = @_;
  my @actions = sort keys %{$self->Templates};
  return "(".join(" ",map {EmacsQuote(Arg => $_)} @actions).')';
}

sub GetLLMResponse {
  my ($self,%args) = @_;

  # in the future move this elsewhere, and just clear it between uses,
  # after we implement that functionality in it
  my $templating_client = LLMs::TemplatingClient->new
    (
     Debug => 1,
     EngineNameOverride => 'RemoteLLM',
     IncludePath => '/var/lib/myfrdcsa/codebases/minor/prompt-library/data-git/prompts/flp',
    );

  print Dumper
    ({
      Files => \@files,
      templating_client => $templating_client,
      Marker => $marker,
      NumLines => $numlines,
     }) if $UNIVERSAL::debug;

  my $dialog_history = $args{DialogHistory};

  my $res2 = $templating_client->TemplatingQuery
    (
     Context => 'context1',
     Args => {
	      dialog_history => $dialog_history,
	     },
     TemplateFullFilename => $self->Templates->{$self->DefaultAction},
     DoNotRecord => 1,
    );

  print Dumper({Res2a => $res2}) if $UNIVERSAL::debug;

  if ($res2->{Success}) {
    print $res2->{Results}."\n";
    return $res2->{Results};
  } else {
    warn "oops\n";
  }
}

1;
