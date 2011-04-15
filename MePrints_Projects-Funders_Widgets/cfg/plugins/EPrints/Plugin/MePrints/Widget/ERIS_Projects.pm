################################################################################
#  EPrints - MePrints - Projects Widget
################################################################################
#  This software was developed as part of the ERIS: Enhancing Repository
#  Infrastructure in Scotland project. This project was funded by JISC as part
#  of the Inf11 programme. This software is dependant on the EPrints
#  Repository software and the MePrints plugin.
#  Author: Stephane Sechaud
#  Email: ssechaud1982@gmail.com
#  For more information please see the links below:
#  JISC Programme details - http://www.jisc.ac.uk/whatwedo/programmes/inf11.aspx
#  ERIS Blog site: http://eriscotland.wordpress.com/
#  EPrints site: http://www.eprints.org/
#  MePrints site: http://files.eprints.org/501/
################################################################################
#  This software is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version. Financial profit derived from this
#  software is strictly prohibited.
#  This software is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#  You should have received a copy of the GNU General Public License
#  along with EPrints; if not, Google it, or write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
################################################################################
package EPrints::Plugin::MePrints::Widget::ERIS_Projects;
use EPrints::Plugin::MePrints::Widget;
@ISA = ('EPrints::Plugin::MePrints::Widget');
use strict;
sub new {
	my($class, %params) = @_;
	my $self = $class->SUPER::new(%params);
	if(!$self->{session}) {
		$self->{session} = $self->{processor}->{session};
	}
	$self->{name} = "EPrints Profile System: Projects Widget";
	$self->{visible} = "all";
	$self->{advertise} = 1;
	$self->{max_display} = 10;
	return $self;
}
sub render_content {
	my($self) = @_;
	my $session = $self->{session};
	my $user = $self->{user};
	my $frag = $session->make_doc_fragment;
	my @data = @{$self->get_projects()};
	my $repo_url = $session->get_repository->get_conf("base_url");
	if(scalar(@data)) {
		my $table = $session->make_element("table");
		my $thead = $session->make_element("thead");
		my $headrow = $session->make_element("tr");
		my $headcell = $session->make_element("th");
		$headrow->appendChild($headcell);
		$headcell->appendChild($session->make_text(""));
		$headcell = $session->make_element("th");
		$headrow->appendChild($headcell);
		$headcell->appendChild($self->html_phrase("projecttitle"));
		$headcell = $session->make_element("th");
		$headcell->appendChild($session->make_text("Items"));
		$headrow->appendChild($headcell);
		$thead->appendChild($headrow);
		$table->appendChild($thead);
		my $tbody = $session->make_element("tbody");
		my $item_count = 0;
		foreach(@data) {
			my $project = $_->{projects};
			my $count = $_->{count};	
			my $tablerow = $session->make_element("tr");
			my $cell = $session->make_element("td");
			$cell->appendChild($session->make_text(++$item_count));
			$tablerow->appendChild($cell);			
			$cell = $session->make_element("td");
            my $url = $repo_url."/cgi/search/simple?q=".$project."&_action_search=Search&_action_search=Search&_order=bytitle&basic_srchtype=ALL&_satisfyall=ALL";
			my $link = $session->make_element("a", href=>"$url");
			$link->appendChild($session->make_text($project));
			$cell->appendChild($link);
			$tablerow->appendChild($cell);
			$tbody->appendChild($tablerow);
			$cell = $session->make_element("td");
			$cell->appendChild($session->make_text("$count"));
			$tablerow->appendChild($cell);
		}
		$table->appendChild($tbody);
		$frag->appendChild($table);
	} else {
		$frag->appendChild($self->html_phrase("noitems"));
	}
	return $frag;
}
sub get_projects {
	my($self) = @_;
	my $user = $self->{user};
	my $session = $self->{session};
	my $ds = $session->get_repository->get_dataset("archive");
	my $list = $user->get_owned_eprints($ds);
	my $limit = $self->{max_display};
	my @data;
	if(!$list->count()){return \@data;}
	my $ids_string = join(",", @{$list->get_ids()});
	my $sql = "SELECT DISTINCT projects, COUNT(projects) FROM eprint_projects WHERE eprintid IN (".$ids_string.") GROUP BY projects ORDER BY COUNT(projects) DESC;";
	my $sth = $self->{session}->get_database->prepare($sql);
	$self->{session}->get_database->execute($sth, $sql);
        while(my(@sresult) = $sth->fetchrow_array) {
            my $project_name = $sresult[0];
            my $count = $sresult[1];
            push @data, {projects=>$project_name, count=>$count};
        };
	return \@data;
}
1;