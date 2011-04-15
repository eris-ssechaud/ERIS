################################################################################
#  EPrints External Subjects DDC Workflow & Template Configuration Script
################################################################################
package EPrints::Plugin::Screen::Admin::ExternalSubjectsDDC;
@ISA = ( 'EPrints::Plugin::Screen' );
use strict;
sub new {
    my ($class,%params) = @_;
    my $self = $class->SUPER::new(%params);
    $self->{actions} = [qw/ postinst prerm /  ];
    $self->{package_name} = "external_subjects_ddc";
    return $self;
}
sub can_be_viewed {
    my($self) = @_;
    return 0;
}
sub allow_action_prerm {
    my($self) = @_;
    return 1;
}
sub allow_action_postinst {
    my($self) = @_;
    return 1;
}
sub action_postinst {
    my($self) = @_;
    my $repository = $self->repository;
    my $filename = $repository->config("config_path")."/workflows/eprints/default.xml";
    my $string = '<workflow xmlns="http://eprints.org/ep3/workflow" xmlns:epc="http://eprints.org/ep3/control"><stage name="core"><component collapse="no"><field ref="external-subjects-ddc" input_lookup_url="{$config{rel_cgipath}}/users/lookup/external-subjects-ddc"/></component></stage></workflow>';
    my $rc = EPrints::XML::add_to_xml($filename, $string, $self->{package_name});
    my $template = $repository->config("config_path")."/templates/default.xml";
    my $template_string = '<?xml version="1.0" standalone="no" ?><!DOCTYPE html SYSTEM "entities.dtd" ><html xmlns="http://www.w3.org/1999/xhtml" xmlns:epc="http://eprints.org/ep3/control"><head><title><epc:pin ref="title" textonly="yes"/> - <epc:phrase ref="archive_name"/></title><epc:pin ref="login_status_header"/><script type="text/javascript" src="{$config{rel_path}}/javascript/auto.js"><!-- padder --></script><style type="text/css" media="screen">@import url(<epc:print expr="$config{rel_path}"/>/style/auto.css);</style><style type="text/css" media="print">@import url(<epc:print expr="$config{rel_path}"/>/style/print.css);</style><link rel="icon" href="{$config{rel_path}}/favicon.ico" type="image/x-icon"/>
    <link rel="shortcut icon" href="{$config{rel_path}}/favicon.ico" type="image/x-icon"/><link rel="Top" href="{$config{frontpage}}"/>
    <link rel="Search" href="{$config{http_cgiurl}}/search"/><epc:pin ref="head"/><style type="text/css" media="screen">@import url(<epc:print expr="$config{rel_path}"/>/style/nojs.css);</style><script type="text/javascript" src="{$config{rel_path}}/javascript/jscss.js"><!-- padder --></script></head><body bgcolor="#ffffff" text="#000000"><epc:pin ref="pagetop"/><div class="ep_tm_header ep_noprint"><div class="ep_tm_logo"><a href="{$config{frontpage}}"><img alt="Logo" src="{$config{rel_path}}{$config{site_logo}}" /></a></div><div><a class="ep_tm_archivetitle" href="{$config{frontpage}}"><epc:phrase ref="archive_name"/></a></div><ul class="ep_tm_menu"><li><a href="{$config{http_url}}"><epc:phrase ref="template/navigation:home" /></a></li><li><a href="{$config{http_url}}/information.html"><epc:phrase ref="template/navigation:about" /></a></li><li><a href="{$config{http_url}}/view/year/"><epc:phrase ref="bin/generate_views:indextitleprefix" /><epc:phrase ref="viewname_eprint_year" /></a></li><li><a href="{$config{http_url}}/view/subjects/"><epc:phrase ref="bin/generate_views:indextitleprefix" /><epc:phrase ref="viewname_eprint_subjects" /></a></li><li><a href="{$config{http_url}}/view/external-subjects-ddc/"><epc:phrase ref="bin/generate_views:indextitleprefix" /><epc:phrase ref="viewname_eprint_external-subjects-ddc" /></a></li>';
    my $template_rc = EPrints::XML::add_to_xml($template, $template_string, $self->{package_name});
    return (0,undef);
}
sub action_prerm {
    my($self) = @_;
    my $repository = $self->repository;
    my $filename = $repository->config("config_path")."/workflows/eprints/default.xml";
    EPrints::XML::remove_package_from_xml($filename, $self->{package_name});
    my $template = $repository->config("config_path")."/templates/default.xml";
    EPrints::XML::remove_package_from_xml($template, $self->{package_name});
    return (0,undef);

}
sub render {
    my($self) = @_;
    return undef;
}
1;
