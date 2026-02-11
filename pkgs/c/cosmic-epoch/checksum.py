
import json
import sys

file = sys.argv[1]

with open(file) as f:
    data = json.load(f)

if not data["package"] is None:
    data["files"] = {}

with open(file, "w") as f:
    json.dump(data, f)
