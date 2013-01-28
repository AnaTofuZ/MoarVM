package Config::BuildEnvironment;
use strict;
use warnings;

sub detect {
    my %config;
    
    if ($^O =~ /MSWin32/) {
        # Windows.
        $config{'os'} = 'Windows';
        
        # We support the Microsoft toolchain.
        if (can_run('cl /nologo /?')) {
            # Ensure we have the other bits.
            return (excuse => 'It appears you have the MS C compiler, but no link!')
                unless can_run('link /nologo /?');
            return (excuse => 'It appears you have the MS C compiler, but no nmake!')
                unless can_run('nmake /nologo /?');
            
            # Set configuration flags.
            $config{'cc'}           = 'cl';
            $config{'copt'}         = '';
            $config{'cdebug'}       = '';
            $config{'cinstrument'}  = '';
            $config{'cmiscflags'}   = '/nologo /Zi -DWIN32';
            $config{'couto'}        = '-Fo';
            $config{'link'}         = 'link';
            $config{'louto'}        = '-out:';
            $config{'lopt'}         = '';
            $config{'ldebug'}       = '';
            $config{'linstrument'}  = '';
            $config{'lmiscflags'}   = '/nologo /debug /NODEFAULTLIB kernel32.lib ws2_32.lib msvcrt.lib mswsock.lib rpcrt4.lib oldnames.lib advapi32.lib shell32.lib';
            $config{'llibs'}        = '';
            $config{'make'}         = 'nmake';
            $config{'exe'}          = '.exe';
            $config{'o'}            = '.obj';
            $config{'rm'}           = 'del';
            $config{'noreturn'}     = '__declspec(noreturn)';
            $config{'noreturngcc'}  = '';
            $config{'cat'}          = 'TYPE';
        }
        else {
            return (excuse => 'So far, we only support building with the Microsoft toolchain on Windows.');
        }
    }
    elsif ($^O =~ /linux/) {
        $config{'os'} = 'Linux';
        
        if (can_run('clang')) {
            $config{'cc'}           = 'clang';
            $config{'copt'}         = '';
            $config{'cdebug'}       = '-g';
            $config{'cinstrument'}  = '-fsanitize=address';
            $config{'cmiscflags'}   = '-fno-omit-frame-pointer -fno-optimize-sibling-calls';
            $config{'couto'}        = '-o ';
            $config{'link'}         = 'clang';
            $config{'louto'}        = '-o ';
            $config{'lopt'}         = '';
            $config{'ldebug'}       = '-g';
            $config{'linstrument'}  = '-fsanitize=address';
            $config{'lmiscflags'}   = '-L 3rdparty/apr/.libs';
            $config{'llibs'}        = '-Wl,-Bstatic -lapr-1 -Wl,-Bdynamic -lpthread -lm';
            $config{'make'}         = 'make';
            $config{'exe'}          = '';
            $config{'o'}            = '.o';
            $config{'rm'}           = 'rm -f';
            $config{'noreturn'}     = '';
            $config{'noreturngcc'}  = '__attribute__((noreturn))';
            $config{'cat'}          = 'cat';
        }
        elsif (can_run('gcc')) {
            $config{'cc'}           = 'gcc';
            $config{'copt'}         = '-O3';
            $config{'cdebug'}       = '-g';
            $config{'cinstrument'}  = '';
            $config{'cmiscflags'}   = '-D_REENTRANT -D_LARGEFILE64_SOURCE';
            $config{'couto'}        = '-o ';
            $config{'link'}         = 'gcc';
            $config{'louto'}        = '-o ';
            $config{'lopt'}         = '-O3';
            $config{'ldebug'}       = '-g';
            $config{'linstrument'}  = '';
            $config{'lmiscflags'}   = '-L 3rdparty/apr/.libs';
            $config{'llibs'}        = '-Wl,-Bstatic -lapr-1 -Wl,-Bdynamic -lpthread -lm';
            $config{'make'}         = 'make';
            $config{'exe'}          = '';
            $config{'o'}            = '.o';
            $config{'rm'}           = 'rm -f';
            $config{'noreturn'}     = '';
            $config{'noreturngcc'}  = '__attribute__((noreturn))';
            $config{'cat'}          = 'cat';
        }
        else {
            return (excuse => 'So far, we only support building with clang or gcc on Linux.');
        }
    }
    else {
        return (excuse => 'No recognized operating system or compiler found.'."  found: $^O");
    }

    $config{cflags}  = join ' ' => @config{qw( cmiscflags cinstrument cdebug copt )};
    $config{ldflags} = join ' ' => @config{qw( lmiscflags linstrument ldebug lopt )};

    return %config;
}

sub can_run {
    my $try = shift;
    my $out = `$try 2>&1`;
    return defined $out && $out ne '';
}

'Leffe';
