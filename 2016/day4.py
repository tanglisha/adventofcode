import re
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

sectorCodes = [getSectorCode(x) for x in codes if isValidCode(x)]
print sum(sectorCodes)
