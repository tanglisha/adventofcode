import re
import string
from collections import Counter

p = re.compile(r"^(.*)\[(.*)\]$")
lettersOnly = re.compile(r"[a-z]+")
numbersOnly = re.compile(r"\d+")

codes = [re.match(p, x).groups() for x in open("4.in")]
#codes = [("totally-real-room-200", "decoy"),
#        ("not-a-real-room-404", "oarel"),
#        ("a-b-c-d-e-f-g-h-987", "abcde"),
#        ("aaaaa-bbb-z-y-x-123", "abxyz")]

def fixSort(sortOfOrdered):
    if not sortOfOrdered or len(sortOfOrdered) == 0: return

    firstCount = sortOfOrdered[0][1]
    countMatchesFirst = [x for x, y in sortOfOrdered if y == firstCount]
    countMatchesFirst.sort()
    sortedFirst = "".join(countMatchesFirst)
    rest = fixSort(sortOfOrdered[len(countMatchesFirst):])
    if rest:
        return "%s%s" % (sortedFirst, rest)
    return sortedFirst

def getLetterCounts(word):
    letters = word.replace("-", "")
    letters = re.search(lettersOnly, letters).group()
    sortOfOrdered = Counter(letters).most_common(10)

    return fixSort(sortOfOrdered)[:5]

def isValidCode(line):
    code = getLetterCounts(line[0])

    if code == line[1]:
        return True
    return False

def getSectorCode(line):
    return int(re.search(numbersOnly, line[0]).group())

def cesar(letter, shift):
    alphabet = string.ascii_lowercase
    shortened_shift = shift % len(alphabet)
    shifted_alphabet = alphabet[shortened_shift:] + alphabet[:shortened_shift]
    table = string.maketrans(alphabet, shifted_alphabet)
    return letter.translate(table)

def translate(word, shift):
    return [cesar(x, shift) for x in word]

validCodes = {x[0]:{"sectorCode": getSectorCode(x),
    "checksum": x[1]} for x in codes if isValidCode(x)}
print "There are %s real rooms" % sum([x["sectorCode"] for x in validCodes.values()])

decrypted = [cesar(x, y["sectorCode"]) for x, y in validCodes.items()]
print [x for x in decrypted if x.find("orth")>=0]
