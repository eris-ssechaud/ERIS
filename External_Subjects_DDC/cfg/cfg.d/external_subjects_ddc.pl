################################################################################
#  EPrints External Subjects DDC Dataset & Browse View Configuration Script
################################################################################
# Define the new dataset.
$c->{datasets}->{external_subjects_ddc} = {
    class => "EPrints::DataObj::ExternalSubjectsDDC",
    sqlname => "external_subjects_ddc",
    datestamp => "datestamp",
    sql_counter => "id",
};
# Add a new browse view for the dataset.
my $view = [ { id => "external-subjects-ddc", fields => "external-subjects-ddc", order => "external-subjects-ddc" } ];
push(@{$c->{browse_views}}, $view );
# Add fields to the new dataset.
$c->add_dataset_field( "external_subjects_ddc", { name=>"id", type=>"counter", required=>1, can_clone=>0, sql_counter=>"id" }, );
$c->add_dataset_field( "external_subjects_ddc", { name=>"eprintid", type=>"int", required=>1 }, );
$c->add_dataset_field( "external_subjects_ddc", { name=>"pos", type=>"int", required=>1 }, );
$c->add_dataset_field( "external_subjects_ddc", { name=>"value", type=>"text", required=>1 }, );
# $c->add_dataset_field( "external_subjects_ddc", { name=>"uri", type=>"text", required=>1 }, );
# Define a new class for the new dataset object.
{
    package EPrints::DataObj::ExternalSubjectsDDC;
    our @ISA = qw{ EPrints::DataObj };
    # Return dataset super class constructor.
    sub new {
        return shift->SUPER::new( @_ );
    }
    sub get_dataset_id {
        my ($self) = @_;
        return "external_subjects_ddc";
    }
}
1;
