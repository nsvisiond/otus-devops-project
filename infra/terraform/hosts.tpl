[docker_swarm_cluster]
%{ for i in range(length(names)) ~}
%{ if split("-", names[i])[0] ==  "master" ~}
${names[i]} ansible_host=${addrs[i]} ip=${addrs[i]}
%{ endif ~}
%{ endfor ~}
%{ for i in range(length(names_node)) ~}
%{ if split("-", names_node[i])[0] ==  "node" ~}
${names_node[i]} ansible_host=${addrs_node[i]} ip=${addrs_node[i]}
%{ endif ~}
%{ endfor ~}

[docker_swarm_worker]
%{ for i in range(length(names_node)) ~}
%{ if split("-", names_node[i])[0] ==  "node" ~}
${names_node[i]} ansible_host=${addrs_node[i]} ip=${addrs_node[i]}
%{ endif ~}
%{ endfor ~}

[docker_swarm_manager]
%{ for i in range(length(names)) ~}
%{ if split("-", names[i])[0] ==  "master" ~}
${names[i]} ansible_host=${addrs[i]} ip=${addrs[i]}
%{ endif ~}
%{ endfor ~}

[gitlab]
%{ for i in range(length(names_gitlab)) ~}
${names_gitlab[i]} ansible_host=${addrs_gitlab[i]} ip=${addrs_gitlab[i]}
%{ endfor ~}

[docker_runner]
%{ for i in range(length(names_docker_runner)) ~}
${names_docker_runner[i]} ansible_host=${addrs_docker_runner[i]} ip=${addrs_docker_runner[i]}
%{ endfor ~}
