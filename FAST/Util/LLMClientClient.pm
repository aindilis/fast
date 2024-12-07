package FAST::Util::LLMClientClient;

# see /var/lib/myfrdcsa/codebases/internal/do/scripts/task-processing.pl

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw ( GetLLMResponse );

use BOSS::Config;
use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

sub GetLLMResponse {
  my (%args) = @_;
  my $action = $args{Action};
  my $marker = $args{Marker};
  my $tempagent = UniLang::Util::TempAgent->new
    (
     RandName => 'FAST-LLM-Client-Client',
    );
  my $res1 = $tempagent->MyAgent->QueryAgent
    (
     Receiver => 'FAST',
     Data => {
	      _DoNotLog => 1,
	      'GetLLMResponse' => {
				   DialogHistory => $args{DialogHistory},
				   DefaultAction => $args{Action},
				  },
	     },
    );

  print Dumper({Res1 => $res1}) if $UNIVERSAL::debug;
  return
    {
     Success => 1,
     Results => $res1,
    };
}

1;
