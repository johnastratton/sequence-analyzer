#!/usr/bin/perl

if ($#ARGV != 1) {
  print "usage: sequences.pl <sequence file name> <format_string>\n";
  exit;
}
$file = "$ARGV[0]";

$formatstring = "$ARGV[1]";

my($rangeStart) = 0;

open(DATA, $file);
while (<DATA>) {
  my($line) = $_;
  chomp($line);
  if ($line =~ /(\d+)/) {
    my($number) = $1;
    if (defined $nextNumber) {
      if ($nextNumber != $number) {
        my($formatted_number) = sprintf($formatstring, $rangeStart);
        print "$formatted_number";
        if ($nextNumber == $rangeStart + 1) {
          print "\n";
        } else {
          my($end_range) = ($nextNumber - 1);
          $formatted_number = sprintf($formatstring, $end_range);
          print " - ";
          print "$formatted_number\n";
        }
        $rangeStart = $number;
      }
      $nextNumber = $number + 1;
    } else {
      $rangeStart = $number;
      $nextNumber = $number + 1;
    }
  }
}

my($formatted_number) = sprintf($formatstring, $rangeStart);
print "$formatted_number";
if ($nextNumber == $rangeStart + 1) {
  print "\n";
} else {
  $formatted_number = sprintf($formatstring, $nextNumber - 1);
  print " - ";
  print "$formatted_number\n";
}

close(DATA);
