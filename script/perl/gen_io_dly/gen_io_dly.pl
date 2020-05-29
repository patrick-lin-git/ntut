#!/usr/bin/perl -w

use strict;
use warnings;

my $fname = $ARGV[0];

open (my $fh, '<:encoding(UTF-8)', $fname) or die "Could not open file $fname";

my $conn;
my @cary;
my $find;
my $repl;

while (my $line = <$fh>) {
 chomp $line;
#if( $line =~ m/\.A\s*\(\s*(\w+)\s*\)\s*/) {
 if( $line =~ m/\.A\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)\s*/) {
# print "wire [1:0] #\`DLY $1"."x"." = $1;\n";
  prn_wire(2, $1);
 }
#if( $line =~ m/\.B\s*\(\s*(\w+)\s*\)\s*/) {
 if( $line =~ m/\.B\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)\s*/) {
# print "$1\n";
  prn_wire(3, $1);
 } 
 if( $line =~ m/\.C\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)\s*/) {
# print "$1\n";
  prn_wire(3, $1);
#  $conn = $1;
#  if( $conn =~ m/\{.*\}/ ) {
#    $conn =~ s/^\s*{\s*//;
#    $conn =~ s/\s*}\s*$//;
#    @cary = split(',', $conn); 
#    foreach my $val (@cary) {
#     $val =~ s/^\s*//;
#     $val =~ s/\s*$//;
#     print_wire(2, $val);
#    }
#  } else {
#    print_wire(2, $1);
#  }
 } 
#if( $line =~ m/\.D\s*\(\s*(\w+)\s*\)\s*/) {
 if( $line =~ m/\.D\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)\s*/) {
# print "$1\n";
  prn_wire(2, $1);
 } 
#if( $line =~ m/\.E\s*\(\s*(\w+)\s*\)\s*/) {
 if( $line =~ m/\.E\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)\s*/) {
# print "$1\n";
  prn_wire(2, $1);
 } 
#if( $line =~ m/\.F\s*\(\s*(\w+)\s*\)\s*/) {
 if( $line =~ m/\.F\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)\s*/) {
# print "$1\n";
  prn_wire(2, $1);
 }
 # print "$line\n";
}

close($fh);
# --------------------------------------------------------------------------------
open ($fh, '<:encoding(UTF-8)', $fname) or die "Could not open file $fname";
while (my $line = <$fh>) {
 chomp $line;

 $line = chg_conn ('A', $line);
#  if( $line =~ m/\.A\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)/) {
#   $conn = $1;
#   $conn =~ s/^\s*{\s*//;
#   $conn =~ s/\s*}\s*$//;
#   $conn =~ s/^\s*//;
#   $conn =~ s/\s*$//;
#   $find = "\\(\\s*$conn\\s*\\)";
#   $repl = "( $conn"."x )";
# # $repl = " $conn"."x ";
# # print "$find\n";
# # print "$repl\n";
#   $line =~ s/$find/$repl/;
#  }

 $line = chg_conn ('B', $line);
#  if( $line =~ m/\.B\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)/) {
#   $conn = $1;
#   $conn =~ s/^\s*{\s*//;
#   $conn =~ s/\s*}\s*$//;
#   $conn =~ s/^\s*//;
#   $conn =~ s/\s*$//;
#   $find = "\\(\\s*$conn\\s*\\)";
#   $repl = "( $conn"."x )";
# # $repl = " $conn"."x ";
# # print "$find\n";
# # print "$repl\n";
#   $line =~ s/$find/$repl/;
#  }

 $line = chg_conn ('C', $line);

#  if( $line =~ m/\.C\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)/) {
#   $conn = $1;
#   if( $conn =~ m/\{.*\}/ ) {
#     $conn =~ s/^\s*{\s*//;
#     $conn =~ s/\s*}\s*$//;
#     @cary = split(',', $conn); 
#     my $conx = "";
#     foreach my $val (@cary) {
#       $val =~ s/^\s+//;
#       $val =~ s/\s+$//;
#     # print_wire($widt, $val);
#       $conx .= $val."x, ";
#     }
#     $find = "\\(\\s*{ $conn }\\s*\\)";
#     $repl = "( $conx )";
#     $line =~ s/$find/$repl/;
#   } else {
#     $conn =~ s/^\s*{\s*//;
#     $conn =~ s/\s*}\s*$//;
#     $conn =~ s/^\s*//;
#     $conn =~ s/\s*$//;
#     $find = "\\(\\s*$conn\\s*\\)";
#     $repl = "( $conn"."x )";
#   # $repl = " $conn"."x ";
#   # print "$find\n";
#   # print "$repl\n";
#     $line =~ s/$find/$repl/;
#   }
#  }

 $line = chg_conn ('D', $line);
#  if( $line =~ m/\.D\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)/) {
#   $conn = $1;
#   $conn =~ s/^\s*{\s*//;
#   $conn =~ s/\s*}\s*$//;
#   $conn =~ s/^\s*//;
#   $conn =~ s/\s*$//;
#   $find = "\\(\\s*$conn\\s*\\)";
#   $repl = "( $conn"."x )";
# # $repl = " $conn"."x ";
# # print "$find\n";
# # print "$repl\n";
#   $line =~ s/$find/$repl/;
#  }

 $line = chg_conn ('E', $line);
#  if( $line =~ m/\.E\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)/) {
#   $conn = $1;
#   $conn =~ s/^\s*{\s*//;
#   $conn =~ s/\s*}\s*$//;
#   $conn =~ s/^\s*//;
#   $conn =~ s/\s*$//;
#   $find = "\\(\\s*$conn\\s*\\)";
#   $repl = "( $conn"."x )";
# # $repl = " $conn"."x ";
# # print "$find\n";
# # print "$repl\n";
#   $line =~ s/$find/$repl/;
#  }

 $line = chg_conn ('F', $line);
#  if( $line =~ m/\.F\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)/) {
#   $conn = $1;
#   $conn =~ s/^\s*{\s*//;
#   $conn =~ s/\s*}\s*$//;
#   $conn =~ s/^\s*//;
#   $conn =~ s/\s*$//;
#   $find = "\\(\\s*$conn\\s*\\)";
#   $repl = "( $conn"."x )";
# # $repl = " $conn"."x ";
# # print "$find\n";
# # print "$repl\n";
#   $line =~ s/$find/$repl/;
#  }

 print "$line\n";
}

sub chg_conn
{
  my $prt_name = shift;
  my $line     = shift;
  my $conn;
  my @cary;
  my $find;
  my $repl;

  $find = "\\.".$prt_name."\\s*\\(\\s*([\\w|\\s|\\{|\\}|\\,]+)\\s*\\)";
# if( $line =~ m/\.A\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)/) {
# if( $line =~ m/\.C\s*\(\s*([\w|\s|\{|\}|\,]+)\s*\)/) {
  if( $line =~ m/$find/) {
    $conn = $1;
    if( $conn =~ m/\{.*\}/ ) {
      $conn =~ s/^\s*{\s*//;
      $conn =~ s/\s*}\s*$//;
      @cary = split(',', $conn); 
      my $conx = "";
      foreach my $val (@cary) {
        $val =~ s/^\s+//;
        $val =~ s/\s+$//;
      # print_wire($widt, $val);
        $conx .= $val."x, ";
      }
      $conx =~ s/, $/ /;
      $find = "\\(\\s*{\\s*$conn\\s*}\\s*\\)";
      $repl = "( $conx )";
      $line =~ s/$find/$repl/;
    } else {
      $conn =~ s/^\s*{\s*//;
      $conn =~ s/\s*}\s*$//;
      $conn =~ s/^\s*//;
      $conn =~ s/\s*$//;
      $find = "\\(\\s*$conn\\s*\\)";
      $repl = "( $conn"."x )";
    # $repl = " $conn"."x ";
    # print "$find\n";
    # print "$repl\n";
      $line =~ s/$find/$repl/;
    }
  }
  return $line;
}

# --------------------------------------------------------------------------------
# --------------------------------------------------------------------------------
sub prn_wire
{
  my $widt = shift; # wire width
  my $conn = shift;
  my @cary;
  if( $conn =~ m/\{.*\}/ ) {
    $conn =~ s/^\s*{\s*//;
    $conn =~ s/\s*}\s*$//;
    @cary = split(',', $conn); 
    foreach my $val (@cary) {
#    $val =~ s/^\s+//;
#    $val =~ s/\s+$//;
     print_wire($widt, $val);
    }
  } else {
#   $conn =~ s/^\s+//;
#   $conn =~ s/\s+$//;
    print_wire($widt, $conn);
  }
}

sub print_wire
{
  my $wd = shift; # wire width
  my $wn = shift; # wire name
  $wn =~ s/^\s+//;
  $wn =~ s/\s+$//;
  print "wire [$wd:0] #\`DLY $wn"."x"." = $wn;\n";
}

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
