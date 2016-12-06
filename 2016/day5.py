from md5 import md5

def getZeroedHash(doorId, index=0):
    """
    >>> getZeroedHash("abc")
    (3231929, '00000155f8105dff7f56ee10fa9b9abd')
    """
    hash = ''

    while not hash.startswith('00000'):
        hash = md5(getHashString(doorId, index)).hexdigest()
        index = index + 1

    return (index-1, hash)

def getHashString(hash, index):
    """
    >>> getHashString("abc", 3231929)
    'abc3231929'
    """
    return "%s%s" % (hash, index)

def getPasswordChar(hash):
    """
    >>> getPasswordChar('00000155f8105dff7f56ee10fa9b9abd')
    '1'
    """
    return hash[5]

def getPassword(doorId):
    """
    >>> getPassword("abc")
    '18f47a30'
    """
    index, hash = getZeroedHash(doorId)
    password = getPasswordChar(hash)

    for x in range(1,8):
        index, hash = getZeroedHash(doorId, index + 1)
        password += getPasswordChar(hash)

    return password

if "__main__" == __name__:
    print getPassword('ugkcyxxp')
    #import doctest
    #doctest.testmod()
