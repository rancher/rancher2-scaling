#!/bin/bash

%{ if is_k3s_server }
  %{ if !install_rancher }
echo "Registration command: \'${registration_command}\'"
${registration_command}
  %{ endif }
%{ endif }
