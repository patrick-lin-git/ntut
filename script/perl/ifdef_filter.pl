#!/usr/bin/perl -w 
#---------------------------------------------------------------------------- 
# Parse all ifdef/else/endif statements in verilog
#---------------------------------------------------------------------------- 
# Keywords that matter: `ifdef, `else, `endif, `define, `include, `undef 
#---------------------------------------------------------------------------- 
# Usage: ifdef_filter.pl <filename.v>
# Parses all verilog include files for `defined text macro's and then comments 
# out appropriate `ifdef, `else, `endif blocks. 
# 
# All valid statements will shift right by 2 space characters in output.
# Include file should placed at current working directory or specify its 
# absoluted full path (environments variable is OK)
#
# It's a good parctice to collect all macro definitions in one single include 
# file. However, this program allow you to place it everywhere in the code 
# just for max its usage.
#
# <`ifndef> <`reset_all> not supported!
#
# Output file: <filename.v>.f
#
#---------------------------------------------------------------------------- 
# Created May 06, 2019 - Patrick Lin
# @TAIWAN (not part of China)
# Bug Report: patrick.lin@gmail.com
#---------------------------------------------------------------------------- 

my $in_file = shift or die "\nUsage: $0 filename\n\n"; 
my $outfile = "$in_file".".f"; 

# holds "define" symbols: $DEFINE{$symbol} = $value 
my %DEFINE;
my $lidx = 0;       # line index
my $lmax = 0;       # mac line number in file read in
my $tmpm = "";      # temporary macro name

my $DEBUG_EN = 1;

sub DBG_MSG {
 if( $DEBUG_EN ) { print "@_\n"; }
}


# -----------------------------------------------------------------------------
sub incl_file {
 my ($fn) = @_;
 my $ff;
 if( $fn =~ m/\$/ ) {       # handle enviroment variable in path
# $fn = "echo \\".$fn;
# print $fn."\n";
# $ff = system $fn;
  $fn =~ s/\//\\\//g;
  # print "===".$fn."===\n";
  $ff = `echo $fn`;
  chomp($ff);
# print "+++".$ff."+++\n";
 } else {
  $ff = $fn;
 }

 if (!-e $ff) {
  die "File: $ff not found\n";
 }

#$fn =~ s/\$//;
 my $fh;
 open ($fh, '<', $ff) or die "Could not open file: \'$ff\' for read, $!";
 
 my @line_ary;
 
 while (my $line = <$fh>) {
  chomp $line;
  if( $line =~ /^\s*\`include\s+\"(.*)\"/ ) {
# if($line =~ m/^\:I(.*)$/) {
   my $fi = $1;
   $fi =~ s/\s*#.*$//;                     # remove # comments at tail
   $fi =~ s/^\s*//;

   if( $DEBUG_EN == 1 ) {
#   print "Found include file directive :I: $fi\n";
#   print "Found file with \'include directive ==> $line, $fi\n";
    print "file: $fi included\n";
   }

   my @incl_ary = incl_file($fi);
   @line_ary = (@line_ary, @incl_ary);
  } else {
   push(@line_ary, $line);
  }
 }                                         # while
 close $fh;
 return @line_ary;
}



# -----------------------------------------------------------------------------
sub proc_ifdef {
 my $care = shift; 
 my $line = $all_line[$lidx];
 my $iidx;
 my $detif;
 my $tmpm;

#print "\n";
#print "CARE: $care\n";
#print "LMAX: $lmax\n";


 $detif = 0;

 if( $care == 1 ) {
# while ( $line ) {
  while ( $lidx < $lmax ) {
   $line = $all_line[$lidx];
   $iidx = $lidx + 1;
#  print " $iidx, $line\n";

   # proc `define and `undef
   if( $line =~ /^\s*\`define\s+(\w+)/ ) {
    if (defined($DEFINE{$1})) { 
     DBG_MSG( "Macro redefined." );
    }
    $DEFINE{$1} = 1;
    print OUTFILE "//$line\n";
    $lidx++;
    $line = $all_line[$lidx];
    next;
   } else {
    if( $line =~ /^\s*\`undef\s+(\w+)/ ) { 
     if (defined($DEFINE{$1})) { 
      delete $DEFINE{$1};
     } else {
      DBG_MSG( "Cannot \'undef an nonexistent define macro." );
      print " $iidx, $line\n";
      exit;
     }
     print OUTFILE "//$line\n";
     $lidx++;
     $line = $all_line[$lidx];
     next;
    }
   }

#  print "$line\n";
#  print "$lidx\n";

   if( $line =~ /^\s*\`ifdef\s+(\w+)\b/ ) {
    $detif = 1;
    $tmpm = $1;
#   print " MCRO: $tmpm\n";
    print OUTFILE "//$line\n";
    $lidx++;
    if (defined($DEFINE{$tmpm})) {
     proc_ifdef(1);
    } else {
     proc_ifdef(0);
    }
   } else {
    if( $line =~ /^\s*\`endif/ ) {
     if( $detif == 1 ) {
      print OUTFILE "//$line\n";
      $lidx++;
      $detif = 0;
     } else {
      return;
     }
    } else {
     if( $line =~ /^\s*\`else/ ) {
      if( $detif == 1 ) {
       print OUTFILE "//$line\n";
       $lidx++;
#      print " TMPM: $tmpm\n";
#      print " XXXX: $lidx\n";
       if( defined($DEFINE{$tmpm}) ) { 
        proc_ifdef(0);
       } else {
        proc_ifdef(1);
       }
      } else {
       return;
      }
     } else {
      $line = $all_line[$lidx];
      print OUTFILE "  $line\n";
      $lidx++;
     }
    }
   }
#  $line = $all_line[$lidx];
#  print OUTFILE "  $line\n";
#  $lidx++;
#  $line = $all_line[$lidx];
  }                                              # while
 } else {                                        # care = 0
# while ( $line ) {
  while ( $lidx < $lmax ) {
   $line = $all_line[$lidx];
#  $iidx = $lidx + 1;
#  print " $iidx, $line\n";
   if( $line =~ /^\s*\`ifdef\s+(\w+)\b/ ) {
    $detif = 1;
    print OUTFILE "//$line\n";
    $lidx++;
    proc_ifdef(0);
   } else {
    if ( $line =~ /^\s*\`else/ ) {
     if( $detif == 1 ) {
      print OUTFILE "//$line\n";
      $lidx++;
      proc_ifdef(0);
     } else {
      return;
     }
    } else {
     if( $line =~ /^\s*\`endif/ ) {
      if( $detif == 1 ) {
       print OUTFILE "//$line\n";
       $lidx++;
       $detif = 0;
      } else {
       return;
      }
     } else {
      $line = $all_line[$lidx];
      print OUTFILE "//$line\n";
      $lidx++;
     }
    }
   }
  }                                              # while
 }
}


# ---------------------------------------------------------
#   Main code
@all_line = incl_file($in_file); 
$lmax = $#all_line;
$lmax++;
# print "LMAX: $lmax\n";
open OUTFILE, ">$outfile" or die "Cannot open $outfile: $!\n"; 
proc_ifdef(1);

print "\nFILE: $outfile is generated\n";
