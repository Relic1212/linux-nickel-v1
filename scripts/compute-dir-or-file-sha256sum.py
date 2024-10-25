#!/usr/bin/env python
import os
import sys

sys.path.append(".")


from builder import hashes


d_or_f=sys.argv[1]

h = hashes.compute_file_or_dir_sha256sum(d_or_f)
print(h)
