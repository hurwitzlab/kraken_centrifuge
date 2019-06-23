#!/usr/bin/env python3
"""
Author : kyclark
Date   : 2019-06-11
Purpose: Rock the Casbah
"""

import argparse
import os
import re
import sys


# --------------------------------------------------
def main():
    """Make a jazz noise here"""

    file = ('/rsgrps/bhurwitz/hurwitzlab/data/kyclark/clark_centrifuge/'
            'fasta/input.fna')
    out_fh = open('seqid2taxid.map', 'wt')

    regex = re.compile('^>(kraken:taxid[|](\d+))')

    for line in open(file):
        match = regex.search(line)
        if match:
            out_fh.write('\t'.join(match.groups()) + '\n')

    print('Done.')

# --------------------------------------------------
if __name__ == '__main__':
    main()
