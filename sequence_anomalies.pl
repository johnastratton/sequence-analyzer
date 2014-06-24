#!/usr/bin/perl

if ($#ARGV != 1) {
  print "usage: sequence_anomalies.pl <sequence file name> <format_string>\n";
  exit;
}
$file = "$ARGV[0]";

$formatstring = "$ARGV[1]";

my($dupsentinel) = 1;
my($major) = 0;
my($minor) = 0;
my($nextMinor) = 1;
my($noncontiguousMinors) = 0;
my($totalmissing) = 0;

open(DATA, $file);
while (<DATA>) {
  my($line) = $_;
  chomp($line);
  if ($line =~ /(\d+)/) {
    my($number) = $1;
    if (defined $nextNumber) {
      if ($nextNumber == ($number + 1)) {
        $dupsentinel = $dupsentinel + 1;
      } else {
      	if ($dupsentinel != 1) {
      		my($postfix) = "\n";
          my($formatted_number) = sprintf($formatstring, $nextNumber - 1);
          if ($noncontiguousMinors != 0) {
          	print "Multi-entry";
            $postfix = "x$dupsentinel (with noncontiguous minors)\n";
          } elsif ($nextMinor == 1) {
            print "Duplicate";
            $postfix = " x$dupsentinel\n";
          } else {
          	print "Multi-entry";
          	$postfix = " 1-$dupsentinel\n";
          }
          print ": $formatted_number $postfix";
        }
        if ($nextNumber != $number) {
          my($formatted_number) = sprintf($formatstring, $nextNumber);
          print "Missing: ";
          print "$formatted_number";
          my($endMissing) = $number - 1;
          if ($nextNumber == $endMissing) {
          	$totalmissing = $totalmissing+1;
            print "\n";
          } else {
          	$totalmissing = $totalmissing + ($number - $nextNumber);
            $formatted_number = sprintf($formatstring, $endMissing);
            print " - ";
            print "$formatted_number\n";
          }
        }
        $dupsentinel = 1;
        $noncontiguousMinors = 0;
        $nextMinor = 1;
      }
    }
    if ($line =~ /(\d+)(\.)(\d+)/) {
      if ($nextMinor != $3) {
        $noncontiguousMinors = 1;
      }
      if ($dupsentinel != 1) {
      	if ($nextMinor == 1) {
          $noncontiguousMinors = 1;
        }
      }
      $nextMinor = $3 + 1;
    } elsif ($nextMinor != 1) {
      $noncontiguousMinors = 1;
    }
    $nextNumber = $number + 1;
  }
}

if ($dupsentinel != 1) {
    my($formatted_number) = sprintf($formatstring, $nextNumber - 1);
    if ($noncontiguousMinors != 0) {
        print "Multi-entry x$dupsentinel";
        print " (with noncontiguous minors)";
    } elsif ($nextMinor == 1) {
        print "Duplicate x$dupsentinel";
    } else {
        print "Multi-entry x$dupsentinel";
    }
    print ": $formatted_number\n";
}

print "Total missing: $totalmissing\n";

close(DATA);
