def taomao(str_inp):
    path_ = "/home/ftp/bin"
    sp = path_.index("ftp")
    j = 0 
    if(sp == -1):
        j = str_inp.index("/")
    else:
        j = str_inp.count("/")
    r = str_inp[j] 
    l = len( r ) + len( path_ )
    if ( l > 32 ): 
        print("`l` is greater than 32")
    buf = path_ + r 
    if ( "%n" in buf ):
        print("FOUND A THREAT !!!")
    print("NO THREAT FOUND ... ")