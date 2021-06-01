#
# Copyright 2021 Centreon (http://www.centreon.com/)
#
# Centreon is a full-fledged industry-strength solution that meets
# the needs in IT infrastructure and application monitoring for
# service performance.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package notification::mattermost::mode::alert;

use base qw(centreon::plugins::mode);

use strict;
use warnings;
use centreon::plugins::http;
use JSON::XS;
use Data::Dumper;


my %telegram_icon_host = (
    up => ":white_check_mark:",
    down => ":fire:",
    unreachable => ":x:",
);
my %telegram_icon_service = (
    ok => ":white_check_mark:",
    warning => ":warning:",
    critical => ":fire:",
    unknown => ":x:",
);
my %telegram_color_host = (
    up => "#87bd23",
    down => "#ed1c24",
    unreachable => "#cdcdcd",
);
my %telegram_color_service = (
    ok => "#87bd23",
    warning => "#ff9913",
    critical => "#ed1c24",
    unknown => "#cdcdcd",
);

sub new {
    my ($class, %options) = @_;
    my $self = $class->SUPER::new(package => __PACKAGE__, %options);
    bless $self, $class;

    $options{options}->add_options(arguments => {
        "hostname:s"            => { name => 'hostname' },
        "port:s"                => { name => 'port' },
        "proto:s"               => { name => 'proto', default => 'http' },
        "urlpath:s"             => { name => 'url_path', default => "/api/v4/posts" },
        "channel-id:s"          => { name => 'channel_id' },
        "message:s"             => { name => 'message' },
        "service-description:s" => { name => 'service_description' },
        "service-state:s" => { name => 'service_state' },
        "service-output:s" => { name => 'service_output' },
        "bearer-token:s"        => { name => 'bearer_token' },
        "host-name:s"           => { name => 'host_name'},
        "host-state:s"          => { name => 'host_state' },
        "notification-type:s"   => { name => 'notification_type' },
        "host-output:s"         => { name => 'host_output' },
        "link-url:s"            => { name => 'link_url' },
        "graph-url:s"            => { name => 'graph_url' },
        "time:s"            => { name => 'time' },
    });

    $self->{http} = centreon::plugins::http->new(%options);
    return $self;
}

sub check_options {
    my ($self, %options) = @_;

    $self->SUPER::init(%options);
    if (!defined($self->{option_results}->{channel_id})) {
        $self->{output}->add_option_msg(short_msg => "You need to set --channel-id option");
        $self->{output}->option_exit();
    }
    if (!defined($self->{option_results}->{message})) {
        $self->{output}->add_option_msg(short_msg => "You need to set --message option");
        $self->{output}->option_exit();
    }
    if (!defined($self->{option_results}->{bearer_token})) {
        $self->{output}->add_option_msg(short_msg => "You need to set --bearer token option");
        $self->{output}->option_exit();
    }
    if (!defined($self->{option_results}->{hostname})) {
        $self->{output}->add_option_msg(short_msg => "You need to set --hostname option");
        $self->{output}->option_exit();
    }

    foreach (('graph_url', 'link_url')) {
        if (defined($self->{option_results}->{$_})) {
            $self->{option_results}->{$_} =~ s/%\{(.*?)\}/$self->{option_results}->{$1}/eg;
        }
    }

    $self->{http}->set_options(%{$self->{option_results}});
}

sub host_message {
  my ($self, %options) = @_;

    if (defined($self->{option_results}->{host_state}) && $self->{option_results}->{host_state} ne '') {
        if (defined($telegram_icon_host{lc($self->{option_results}->{host_state})})) {
            $self->{title} ='### '.$telegram_icon_host{lc($self->{option_results}->{host_state})};
        }
    }
    if (defined($self->{option_results}->{host_state}) && $self->{option_results}->{host_state} ne '') {
        if (defined($telegram_color_host{lc($self->{option_results}->{host_state})})) {
            $self->{color} =$telegram_color_host{lc($self->{option_results}->{host_state})};
        }
    }
    if (defined($self->{option_results}->{host_name}) && $self->{option_results}->{host_name} ne '') {
        $self->{title}.=' *'.$self->{option_results}->{host_name}.'*';
    } 
    if (defined($self->{option_results}->{host_state}) && $self->{option_results}->{host_state} ne '') {
        $self->{title}.=' is **'.uc($self->{option_results}->{host_state}). '** - ';
    }
    else {
        $self->{title} .= ' alert';
    }

    if (defined($self->{option_results}->{notification_type}) && $self->{option_results}->{notification_type} ne '') {
        $self->{title} .= '**' . $self->{option_results}->{notification_type}.'**';
    }
    if (defined($self->{option_results}->{host_output}) && $self->{option_results}->{host_output} ne '') {
        $self->{message1} .= '>'.
'#### '.$self->{option_results}->{host_output};
    }
    if (defined($self->{option_results}->{time}) && $self->{option_results}->{time} ne '') {
        $self->{message2} .= '##### :clock1: 
        **'.$self->{option_results}->{time}."**
";
    }
    else{
       $self->{message2} .= '##### :clock1: **'.localtime()."**
"; 
    }
    if (defined($self->{option_results}->{link_url}) && $self->{option_results}->{link_url} ne '') {
        $self->{message3} .= "##### :link: [Link](" . $self->{option_results}->{link_url} . ")";
    }
}

sub service_message {
    my ($self, %options) = @_;

    if (defined($self->{option_results}->{service_state}) && $self->{option_results}->{service_state} ne '') {
        if (defined($telegram_icon_service{lc($self->{option_results}->{service_state})})) {
            $self->{title} ='### '.$telegram_icon_service{lc($self->{option_results}->{service_state})};
        }
    }
    if (defined($self->{option_results}->{service_state}) && $self->{option_results}->{service_state} ne '') {
        if (defined($telegram_color_service{lc($self->{option_results}->{service_state})})) {
            $self->{color} =$telegram_color_service{lc($self->{option_results}->{service_state})};
        }
    }
    
    if (defined($self->{option_results}->{host_name}) && $self->{option_results}->{host_name} ne '') {
        $self->{title}.=' *'.$self->{option_results}->{host_name}.'*';
    } 
    if (defined($self->{option_results}->{service_description}) && $self->{option_results}->{service_description} ne '') {
        $self->{title}.=" - ".$self->{option_results}->{service_description}.' is **';
    } else {
        $self->{title} .= ' alert';
    }
    
    if (defined($self->{option_results}->{service_state}) && $self->{option_results}->{service_state} ne '') {
        $self->{title} .= $self->{option_results}->{service_state}. '** | ';
    }
    if (defined($self->{option_results}->{notification_type}) && $self->{option_results}->{notification_type} ne '') {
        $self->{title} .= '**' . $self->{option_results}->{notification_type}.'**';
    }
    if (defined($self->{option_results}->{service_output}) && $self->{option_results}->{service_output} ne '') {
        $self->{message1} .= '>'.
'#### '.$self->{option_results}->{service_output};
    }
    if (defined($self->{option_results}->{time}) && $self->{option_results}->{time} ne '') {
        $self->{message2} .= '##### :clock1: **'.$self->{option_results}->{time}."**
";
    }
    else{
       $self->{message2} .= '##### :clock1: **'.localtime()."**
"; 
    }
    if (defined($self->{option_results}->{link_url}) && $self->{option_results}->{link_url} ne '') {
        $self->{message3} .= "##### :link: [Link](" . $self->{option_results}->{link_url} . ")";
    }
}

sub set_payload {
    my ($self, %options) = @_;

    if (defined($self->{option_results}->{service_description}) && $self->{option_results}->{service_description} ne '') {
        $self->service_message();
    } else {
        $self->host_message();
    }
}

sub format_payload {
    my ($self, %options) = @_;

    my $json = JSON::XS->new->utf8;

    my $payload = {
        channel_id =>$self->{option_results}->{channel_id},
        props => { attachments => [
            {
            fallback => $self->{option_results}->{message},
            color => $self->{color},
            fields=>[
                {
                   short => "false",
                   value => $self->{title}
                },
                {
                   short => "false",
                   value => $self->{message1}
                },
                {
                   short => "true",
                   value => $self->{message2}
                },
                {
                   short => "true",
                   value => $self->{message3}
                }
            ]
            }
        ]
        }
    };
    eval {
        $self->{payload_str} = $json->encode($payload);
    };
    if ($@) {
        $self->{output}->add_option_msg(short_msg => "Cannot encode json request");
        $self->{output}->option_exit();
    }
}


sub run {
    my ($self, %options) = @_;

    $self->{http}->add_header(key => 'Content-Type', value => 'application/json');
    $self->{http}->add_header(key => 'Authorization', value => 'Bearer ' . $self->{option_results}->{bearer_token});

    $self->set_payload();
    $self->format_payload();

    my $url_path = $self->{option_results}->{url_path};
    my $response = $self->{http}->request(
        url_path => $url_path,
        method => 'POST', query_form_post => $self->{payload_str}
    );
    my $decoded;
    eval {
        $decoded = JSON::XS->new->utf8->decode($response);
    };
    if ($@) {
        $self->{output}->add_option_msg(short_msg => "Cannot decode json response: $@");
        $self->{output}->option_exit();
    }
    if (!defined($decoded->{result}->{id})) {
        $self->{output}->output_add(long_msg => $decoded, debug => 1);
        $self->{output}->add_option_msg(short_msg => "Error sending message");
        $self->{output}->option_exit();
    }

    $self->{output}->output_add(short_msg => 'Message ID : ' . $decoded->{result}->{id});
    $self->{output}->display(force_ignore_perfdata => 1);
    $self->{output}->exit();
}

1;

__END__

=head1 MODE

Send message with Telegram API.

=over 6

=item B<--chat-id>

Telegram Chat ID (Negative Integer for Group)
Use Telegram CLI for getting Chat ID

=item B<--bot-token>

Telegram Bot Token (Check Telegram Doc for Creating Bot)
https://core.telegram.org/bots#3-how-do-i-create-a-bot

=item B<--host-state>

Specify host server state for the alert.

=item B<--host-output>

Specify host server output message for the alert.

=item B<--host-name>

Specify host server name for the alert (Required).

=item B<--service-description>

Specify service description name for the alert.

=item B<--service-state>

Specify service state for the alert.

=item B<--service-output>

Specify service output message for the alert.

=item B<--centreon-url>

Specify the centreon url macro (could be used in link-url and graph-url option).

=item B<--centreon-token>

Specify the centreon token for autologin macro (could be used in link-url and graph-url option).

=item B<--graph-url>

Specify the graph url (Example: %{centreon_url}/include/views/graphs/generateGraphs/generateImage.php?username=myuser&token=%{centreon_token}&hostname=%{host_name}&service=%{service_description}).

=item B<--link-url>

Specify the link url (Example: %{centreon_url}/main.php?p=20201&o=svc&host_search=%{host_name}&svc_search=%{service_description})

=item B<--timeout>

Threshold for HTTP timeout.

=back

=cut
