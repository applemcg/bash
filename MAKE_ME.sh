_functions () 
{ 
    set | awk 'NF == 2 && $2 ~ /^[(][)]$/ { print $1 }'
}
_mk_msg () 
{ 
    printf "$* ? " > /dev/tty;
    read a < /dev/tty
}
_mk_one () 
{ 
    ( echo ONE $1 $PWD;
    _functions | wc ) >> $err;
    dirs;
    _mk_msg wc -l $(wc -l $err)
}
_mk_funw () 
{ 
    grep "^$1 [(][)]" ./*lib ./*/*lib
}
_mk_init () 
{ 
    make_initialize 2>> $err;
    _mk_one INIT
}
_mk_here () 
{ 
    mk_dot 2>> $err;
    _mk_one HERE
}
_acd () 
{ 
    cd $1;
    $2;
    _mk_one $2
}
_mk_run () 
{
    case $PWD in
	$HOME)
	    return;;
    esac
    unset $( _functions| grep -v '^_' );
    _functions;
    dirs -c;
    err=$PWD/make.err;
    rm -f $err;
    _mk_one;
    [[ -d ./make ]] || { cd ..; _mk_run; }
    cd ./make;
    . mklib;
    _acd ../make _mk_here;
    _acd ../smpub _mk_here;
    _functions | grep public_variable
    _mk_msg public_variable 
    _acd ../shelf _mk_here;
    _functions | grep -v '^_' | sort > ../mkfuns.txt;
    _mk_msg all MK wc -l $(wc -l ../mkfuns.txt);
    _acd ../shelf _mk_init;
    _acd ../smpub _mk_init;
    _acd ../make _mk_init;
    _functions | grep -v '^_' | sort > ../initfuns.txt;

    _mk_msg all INIT wc -l $(wc -l ../initfuns.txt);
    _acd ../shelf public_update;
    _acd ../smpub public_update;
    _acd ../make public_update;
    _acd .. dirs
    _mk_msg TIME to QUIT
    return
    echo NEVER Get HERE
}
echo _mk_run
