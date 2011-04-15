################################################################################
#  EPrints Email Reminder Settings Plugin
################################################################################
#  This software was developed as part of the ERIS: Enhancing Repository
#  Infrastructure in Scotland project. This project was funded by JISC as part
#  of the Inf11 programme. This software is dependant on the EPrints
#  Repository software.
#  Author: Stephane Sechaud
#  Email: ssechaud1982@gmail.com
#  For more information please see the links below:
#  JISC Programme details - http://www.jisc.ac.uk/whatwedo/programmes/inf11.aspx
#  ERIS Blog site: http://eriscotland.wordpress.com/
#  EPrints site: http://www.eprints.org/
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
package EPrints::Plugin::Screen::User::ERISEmailReminders;
@ISA = ( 'EPrints::Plugin::Screen' );
use strict;
sub new {
	my( $class, %params ) = @_;
	my $self = $class->SUPER::new(%params);
	$self->{actions} = [qw/ emailremindersettings cancel /];
	$self->{appears} = [
		{	place => "user_actions",
			position => 999,
		},
	];
	return $self;
}
sub can_be_viewed {
	my ( $self ) = @_;
	if(defined $self->{session}->current_user) {
	    my $session = $self->{session};
	    my $usertype = $session->current_user->get_value( "usertype" );
	    return 1 if( $usertype eq "user" );
	}
	return 0;
}
sub render {
	my( $self ) = @_;
	my $session = $self->{session};
	my $userid = $session->current_user->get_value( "userid" );
	my $useremail = $session->current_user->get_value( "email" );
	my $username = $session->current_user->get_value( "username" );
	my $html = $session->make_doc_fragment;
	my $email_div = $session->make_element( "div", class=>"email_reminders_box" );
	my $sth = $session->get_database->prepare_select("SELECT * FROM user_email_reminders WHERE userid = $userid");
	$sth->execute();
	if(my @value = $sth->fetchrow_array){
		my $enable = $value[1];
		my $user_email = $value[2];
		my $frequency = $value[3];
		my $full_text = $value[5];
		my $stats = $value[6];
		my $form = $session->render_form( "POST" );
		# Enable Reminders Selection
		if ($enable eq 0) {
			my $enable_div = $session->make_element( "div", style=>"padding: 5px;" );
			$enable_div->appendChild( $self->html_phrase( "email_enable" ) );
			my $enable_select = $session->make_element( "select", name => "enable_reminders" );
			my $enable_option = $session->make_element( "option", value => "0", selected => "selected" );
			$enable_option->appendChild( $session->make_text("Off") );
			$enable_select->appendChild( $enable_option );
			my $enable_option = $session->make_element( "option", value => "1" );
			$enable_option->appendChild( $session->make_text("On") );
			$enable_select->appendChild( $enable_option );
			$enable_div->appendChild( $enable_select );
			$form->appendChild( $enable_div );
		}else{
			my $enable_div = $session->make_element( "div", style=>"padding: 5px;" );
			$enable_div->appendChild( $self->html_phrase( "email_enable" ) );
			my $enable_select = $session->make_element( "select", name => "enable_reminders" );
			my $enable_option = $session->make_element( "option", value => "0" );
			$enable_option->appendChild( $session->make_text("Off") );
			$enable_select->appendChild( $enable_option );
			my $enable_option = $session->make_element( "option", value => "1", selected => "selected" );
			$enable_option->appendChild( $session->make_text("On") );
			$enable_select->appendChild( $enable_option );
			$enable_div->appendChild( $enable_select );
			$form->appendChild( $enable_div );
		};
		# Frequency Selection
		if ($frequency eq 1) {
			my $frequency_div = $session->make_element( "div", style=>"padding: 5px;" );
			$frequency_div->appendChild( $self->html_phrase( "frequency" ) );
			my $select = $session->make_element( "select", name => "frequency_setting" );
			my $option = $session->make_element( "option", value => "1", selected => "selected" );
			$option->appendChild( $session->make_text("Monthly") );
			$select->appendChild( $option );
			my $option = $session->make_element( "option", value => "2" );
			$option->appendChild( $session->make_text("Bi-Monthly") );
			$select->appendChild( $option );
			my $option = $session->make_element( "option", value => "4" );
			$option->appendChild( $session->make_text("Quarterly") );
			$select->appendChild( $option );
			$frequency_div->appendChild( $select );
			$form->appendChild( $frequency_div );
		};
		if ($frequency eq 2) {
			my $frequency_div = $session->make_element( "div", style=>"padding: 5px;" );
			$frequency_div->appendChild( $self->html_phrase( "frequency" ) );
			my $select = $session->make_element( "select", name => "frequency_setting" );
			my $option = $session->make_element( "option", value => "1" );
			$option->appendChild( $session->make_text("Monthly") );
			$select->appendChild( $option );
			my $option = $session->make_element( "option", value => "2", selected => "selected" );
			$option->appendChild( $session->make_text("Bi-Monthly") );
			$select->appendChild( $option );
			my $option = $session->make_element( "option", value => "4" );
			$option->appendChild( $session->make_text("Quarterly") );
			$select->appendChild( $option );
			$frequency_div->appendChild( $select );
			$form->appendChild( $frequency_div );
		;}
		if ($frequency eq 4) {
			my $frequency_div = $session->make_element( "div", style=>"padding: 5px;" );
			$frequency_div->appendChild( $self->html_phrase( "frequency" ) );
			my $select = $session->make_element( "select", name => "frequency_setting" );
			my $option = $session->make_element( "option", value => "1" );
			$option->appendChild( $session->make_text("Monthly") );
			$select->appendChild( $option );
			my $option = $session->make_element( "option", value => "2" );
			$option->appendChild( $session->make_text("Bi-Monthly") );
			$select->appendChild( $option );
			my $option = $session->make_element( "option", value => "4", selected => "selected" );
			$option->appendChild( $session->make_text("Quarterly") );
			$select->appendChild( $option );
			$frequency_div->appendChild( $select );
			$form->appendChild( $frequency_div );
		};
		# Email Address Input
		my $title_div = $session->make_element( "div", style=>"padding: 5px;" );
		$title_div->appendChild( $self->html_phrase( "email_address" ) );
		$title_div->appendChild(
		$session->render_input_field (
			class => "ep_form_text",
			type => "text",
			name => "email_address",
			size => 70,
			value => "$user_email" )
		);
		$form->appendChild( $title_div );
		# Enable Full-Text Selection
		if ($full_text eq 0) {
			my $fulltext_div = $session->make_element( "div", style=>"padding: 5px;" );
			$fulltext_div->appendChild( $self->html_phrase( "fulltext_enable" ) );
			my $fulltext_select = $session->make_element( "select", name => "fulltext_reminders" );
			my $fulltext_option = $session->make_element( "option", value => "0", selected => "selected" );
			$fulltext_option->appendChild( $session->make_text("Off") );
			$fulltext_select->appendChild( $fulltext_option );
			my $fulltext_option = $session->make_element( "option", value => "1" );
			$fulltext_option->appendChild( $session->make_text("On") );
			$fulltext_select->appendChild( $fulltext_option );
			$fulltext_div->appendChild( $fulltext_select );
			$form->appendChild( $fulltext_div );
		}else{
			my $fulltext_div = $session->make_element( "div", style=>"padding: 5px;" );
			$fulltext_div->appendChild( $self->html_phrase( "fulltext_enable" ) );
			my $fulltext_select = $session->make_element( "select", name => "fulltext_reminders" );
			my $fulltext_option = $session->make_element( "option", value => "0" );
			$fulltext_option->appendChild( $session->make_text("Off") );
			$fulltext_select->appendChild( $fulltext_option );
			my $fulltext_option = $session->make_element( "option", value => "1", selected => "selected" );
			$fulltext_option->appendChild( $session->make_text("On") );
			$fulltext_select->appendChild( $fulltext_option );
			$fulltext_div->appendChild( $fulltext_select );
			$form->appendChild( $fulltext_div );
		};
		# Enable Stats Selection
		if ($stats eq 0) {
			my $stats_div = $session->make_element( "div", style=>"padding: 5px;" );
			$stats_div->appendChild( $self->html_phrase( "stats_enable" ) );
			my $stats_select = $session->make_element( "select", name => "stats_reminders" );
			my $stats_option = $session->make_element( "option", value => "0", selected => "selected" );
			$stats_option->appendChild( $session->make_text("Off") );
			$stats_select->appendChild( $stats_option );
			my $stats_option = $session->make_element( "option", value => "1" );
			$stats_option->appendChild( $session->make_text("On") );
			$stats_select->appendChild( $stats_option );
			$stats_div->appendChild( $stats_select );
			$form->appendChild( $stats_div );
		}else{
			my $stats_div = $session->make_element( "div", style=>"padding: 5px;" );
			$stats_div->appendChild( $self->html_phrase( "stats_enable" ) );
			my $stats_select = $session->make_element( "select", name => "stats_reminders" );
			my $stats_option = $session->make_element( "option", value => "0" );
			$stats_option->appendChild( $session->make_text("Off") );
			$stats_select->appendChild( $stats_option );
			my $stats_option = $session->make_element( "option", value => "1", selected => "selected" );
			$stats_option->appendChild( $session->make_text("On") );
			$stats_select->appendChild( $stats_option );
			$stats_div->appendChild( $stats_select );
			$form->appendChild( $stats_div );
		};
		my $body_div = $session->make_element( "div", style=>"padding: 5px;" );
		my %buttons = (
			emailremindersettings => $self->phrase( "action:emailremindersettings:title" ),
			cancel => $self->phrase( "action:cancel:title" ),
			_order => [ "emailremindersettings", "cancel" ]
		);
		$body_div->appendChild( $session->render_action_buttons( %buttons ) );
		$form->appendChild( $session->render_hidden_field( "screen", $self->{processor}->{screenid} ) );
		$form->appendChild( $body_div );

		$email_div->appendChild($session->render_toolbox( undef, $form ) );
		$html->appendChild( $email_div );
		return $html;
	}else{
		# Default values.
		my $enable = 0;
		my $frequency = 1;
		my $full_text = 0;
		my $stats = 0;
		my $date_last_sent = eris_get_date();
		my $sql = "INSERT INTO `eris`.`user_email_reminders` (`userid`, `enable`, `email`, `frequency`, `date_last_sent`, `full_text`, `stats`) VALUES (\'$userid\', \'$enable\', \'$useremail\', \'$frequency\', \'$date_last_sent\', \'$full_text\', \'$stats\');";
		my $sth2 = $session->get_database->prepare($sql);
		$sth2->execute();
		$sth2->finish();
		my $form = $session->render_form( "POST" );
		# Enable Reminders Selection
		my $enable_div = $session->make_element( "div", style=>"padding: 5px;" );
		$enable_div->appendChild( $self->html_phrase( "email_enable" ) );
		my $enable_select = $session->make_element( "select", name => "enable_reminders" );
		my $enable_option = $session->make_element( "option", value => "0" );
		$enable_option->appendChild( $session->make_text("Off") );
		$enable_select->appendChild( $enable_option );
		my $enable_option = $session->make_element( "option", value => "1" );
		$enable_option->appendChild( $session->make_text("On") );
		$enable_select->appendChild( $enable_option );
		$enable_div->appendChild( $enable_select );
		$form->appendChild( $enable_div );
		# Frequency Selection
		my $frequency_div = $session->make_element( "div", style=>"padding: 5px;" );
		$frequency_div->appendChild( $self->html_phrase( "frequency" ) );
		my $select = $session->make_element( "select", name => "frequency_setting" );
		my $option = $session->make_element( "option", value => "1" );
		$option->appendChild( $session->make_text("Monthly") );
		$select->appendChild( $option );
		my $option = $session->make_element( "option", value => "2" );
		$option->appendChild( $session->make_text("Bi-Monthly") );
		$select->appendChild( $option );
		my $option = $session->make_element( "option", value => "4" );
		$option->appendChild( $session->make_text("Quarterly") );
		$select->appendChild( $option );
		$frequency_div->appendChild( $select );
		$form->appendChild( $frequency_div );
		# Email Address Input
		my $title_div = $session->make_element( "div", style=>"padding: 5px;" );
		$title_div->appendChild( $self->html_phrase( "email_address" ) );
		$title_div->appendChild(
		$session->render_input_field (
			class => "ep_form_text",
			type => "text",
			name => "email_address",
			size => 70,
			value => "$useremail" )
		);
		$form->appendChild( $title_div );
		# Enable Full-Text Selection
		my $fulltext_div = $session->make_element( "div", style=>"padding: 5px;" );
		$fulltext_div->appendChild( $self->html_phrase( "fulltext_enable" ) );
		my $fulltext_select = $session->make_element( "select", name => "fulltext_reminders" );
		my $fulltext_option = $session->make_element( "option", value => "0" );
		$fulltext_option->appendChild( $session->make_text("Off") );
		$fulltext_select->appendChild( $fulltext_option );
		my $fulltext_option = $session->make_element( "option", value => "1" );
		$fulltext_option->appendChild( $session->make_text("On") );
		$fulltext_select->appendChild( $fulltext_option );
		$fulltext_div->appendChild( $fulltext_select );
		$form->appendChild( $fulltext_div );
		# Enable Stats Selection
		my $stats_div = $session->make_element( "div", style=>"padding: 5px;" );
		$stats_div->appendChild( $self->html_phrase( "stats_enable" ) );
		my $stats_select = $session->make_element( "select", name => "stats_reminders" );
		my $stats_option = $session->make_element( "option", value => "0" );
		$stats_option->appendChild( $session->make_text("Off") );
		$stats_select->appendChild( $stats_option );
		my $stats_option = $session->make_element( "option", value => "1" );
		$stats_option->appendChild( $session->make_text("On") );
		$stats_select->appendChild( $stats_option );
		$stats_div->appendChild( $stats_select );
		$form->appendChild( $stats_div );
		my $body_div = $session->make_element( "div", style=>"padding: 5px;" );
		my %buttons = (
			emailremindersettings => $self->phrase( "action:emailremindersettings:title" ),
			cancel => $self->phrase( "action:cancel:title" ),
			_order => [ "emailremindersettings", "cancel" ]
		);
		$body_div->appendChild( $session->render_action_buttons( %buttons ) );
		$form->appendChild( $session->render_hidden_field( "screen", $self->{processor}->{screenid} ) );
		$form->appendChild( $body_div );

		$email_div->appendChild($session->render_toolbox( undef, $form ) );
		$html->appendChild( $email_div );
		return $html;
	};
	$sth->finish();
	return $html;
}
sub allow_emailremindersettings {
	my ( $self ) = @_;
	return 1;
}
sub action_emailremindersettings {
	my ( $self ) = @_;
	my $session = $self->{session};
	my $userid = $session->current_user->get_value( "userid" );
	my $enable = $session->param( "enable_reminders" );
	my $user_email = $session->param( "email_address" );
	my $frequency = $session->param( "frequency_setting" );
	my $full_text = $session->param( "fulltext_reminders" );
	my $stats = $session->param( "stats_reminders" );
	my $sql = "UPDATE `eris`.`user_email_reminders` SET `userid` = \'$userid\', `enable` = \'$enable\', `email` = \'$user_email\', `frequency` = \'$frequency\', `full_text` = \'$full_text\', `stats` = \'$stats\' WHERE `user_email_reminders`.`userid` = $userid;";
	my $sth3 = $session->get_database->prepare($sql);
	$sth3->execute();
	$sth3->finish();
	$self->{processor}->add_message( "message", $self->html_phrase( "summary" ) );
}
sub allow_cancel {
	my ( $self ) = @_;
	return 1;
}
sub action_cancel {
	my ( $self ) = @_;
	$self->{processor}->{screenid} = "User::Homepage";
}
sub eris_get_date{
    (my $day, my $month, my $year) = (localtime)[3,4,5];
    my $current_date = sprintf '%04d-%02d-%02d', $year+1900, $month+1, $day;
    return $current_date;
};
1;