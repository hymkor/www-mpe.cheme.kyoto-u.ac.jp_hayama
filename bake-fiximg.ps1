. .\bake.ps1

bake "." ".\docs" {
    param($from,$to)
    nkf32 -w $from | perl -pe 'binmode(STDIN);binmode(STDOUT);s|"/image/|"/www-mpe.cheme.kyoto-u.ac.jp_hayama/img/|g' > $to
}
