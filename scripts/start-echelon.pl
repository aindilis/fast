#!/usr/bin/env perl

## Ensure you use `conda create -n whisper-ctranslate2 python==3.9`.

## Later versions than 3.9 don't seem to work.

## First make sure it's not already running.

my $result = `killall-grep-nonroot whisper-ctranslate2`;

# then initialize the environment

my $command = 'cd /var/lib/myfrdcsa/sandbox/whisper-ctranslate2-20231011/whisper-ctranslate2-20231011 && . /var/lib/myfrdcsa/codebases/internal/myfrdcsa/scripts/start-conda.sh && conda activate whisper-ctranslate2 && whisper-ctranslate2 --live_transcribe True --live_volume_threshold 0.0125 --model large-v2 --language en';

system $command;
