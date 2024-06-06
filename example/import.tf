# import {
#   to = module.kubernetes.maas_machine.kube[0]
#   id = "kube-0.appkins.io"
# }
#
# import {
#   to = module.kubernetes.maas_machine.kube[1]
#   id = "kube-1.appkins.io"
# }
#
# import {
#   to = module.kubernetes.maas_fabric.default
#   id = "default"
# }
#
# import {
#   to = module.kubernetes.maas_dns_domain.default
#   id = "appkins.io"
# }
#
# import {
#   to = module.kubernetes.maas_space.default
#   id = "default"
# }
#
# import {
#   to = module.kubernetes.maas_vlan.default
#   id = "default:10"
# }
#
# import {
#   to = module.kubernetes.maas_subnet.default
#   id = "10.1.0.0/16"
# }
#
# import {
#   to = module.kubernetes.maas_machine.kube[2]
#   id = "kube-2.appkins.io"
# }
#
import {
  to = module.kubernetes.module.bootstrap.module.argocd.kubernetes_secret.secret
  id = "argocd/github"
}
