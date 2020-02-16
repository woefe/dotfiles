$preview_continuous_mode = 1;
$pdf_previewer = "start zathura %O %S";
#$pdf_previewer = "start evince %O %S";
$pdf_mode = 1;
$out_dir = "build";
@default_files = ("*.tex");

add_cus_dep( 'acn', 'acr', 0, 'makeglossaries' );
add_cus_dep( 'glo', 'gls', 0, 'makeglossaries' );
$clean_ext .= " acr acn alg glo gls glg";
sub makeglossaries {
    my ($base_name, $path) = fileparse( $_[0] );
    pushd $path;
    my $return = system "makeglossaries", $base_name;
    popd;
    return $return;
}
