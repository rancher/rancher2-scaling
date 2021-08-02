#!/bin/bash

%{ if is_k3s_server }
  %{ if !install_rancher }
echo "\'${registration_command}\'"
${registration_command}
  %{ endif }
%{ endif }
