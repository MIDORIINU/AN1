#!/usr/bin/env python 

import chardet
from glob import glob


globPath = "./*.m"


def read(filename, encoding=None, min_confidence=0.5):
    """Return the contents of 'filename' as some encoding."""
    with open(filename, "rb") as f:
        text = f.read()

    guess = chardet.detect(text)

    if guess["confidence"] < min_confidence:
        raise UnicodeDecodeError

    text = text.decode(guess["encoding"]).encode(encoding)    

    return text


for file in glob(globPath):
    print("Converting " + file)

    text=read(file, "cp1252")

    with open(file, "wb") as f:
        f.write(text)




