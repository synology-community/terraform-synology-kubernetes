locals {
  values = {
    applicationSet = {
      replicas = 1
    }
    configs = {
      cm = {
        "dex.config" = yamlencode({
          connectors = [{
            type = "github"
            id   = "github"
            name = "GitHub"
            config = {
              clientID      = var.github.client_id
              clientSecret  = var.github.client_secret
              loadAllGroups = true
              orgs = [{
                name = var.github.org
              }]
            }
          }]
        })
        "exec.enabled"           = true
        "kustomize.buildOptions" = "--enable-helm"
        "resource.customizations.ignoreResourceUpdates.argoproj.io_Application" = yamlencode({
          ignoreDifferences = [{
            jsonPointers = ["/spec/source/targetRevision"]
          }]
          "health.lua" = <<-EOT
          hs = {}
          hs.status = "Progressing"
          hs.message = ""
          if obj.status ~= nil then
            if obj.status.health ~= nil then
              hs.status = obj.status.health.status
              if obj.status.health.message ~= nil then
                hs.message = obj.status.health.message
              end
            end
          end
          return hs
          EOT
        })
        url = "https://argocd.${var.domain}"
      }
      credentialTemplates = {
        https-creds = {
          password = var.github.access_token
          url      = "https://github.com/${var.github.org}"
          username = "ArgoCD"
        }
      }
      params = {
        "server.insecure"        = true
        "server.x.frame.options" = ""
      }
      rbac = {
        "policy.csv" = <<-EOT
      p, role:org-admin, applications, *, */*, allow
      p, role:org-admin, clusters, *, *, allow
      p, role:org-admin, repositories, *, *, allow
      p, role:org-admin, projects, *, *, allow
      p, role:org-admin, logs, *, *, allow
      p, role:org-admin, exec, *, */*, allow
      g, ${var.github.org}:admin, role:org-admin
      EOT
      }
    }
    controller = {
      replicas = 1
    }
    crds = {
      keep = false
    }
    fullnameOverride = "argocd"
    nameOverride     = "argocd"
    redis-ha = {
      enabled = true
    }
    repoServer = {
      extraContainers = [
        {
          env = [
            {
              name  = "ARGOCD_ENV_AVP_TYPE"
              value = "kubernetessecret"
            },
          ]
          image = "ghcr.io/crumbhole/lovely-vault-plugin:0.21.1"
          name  = "lovely-plugin"
          securityContext = {
            runAsNonRoot = true
            runAsUser    = 999
          }
          volumeMounts = [
            {
              mountPath = "/var/run/argocd"
              name      = "var-files"
            },
            {
              mountPath = "/home/argocd/cmp-server/plugins"
              name      = "plugins"
            },
            {
              mountPath = "/tmp"
              name      = "cmp-tmp"
            },
          ]
        },
      ]
      replicas = 2
      volumes = [
        {
          emptyDir = {}
          name     = "cmp-tmp"
        },
      ]
    }
    server = {
      extensions = {
        enabled = true
      }
      ingress = {
        enabled = true
        hosts = [
          "argocd.${var.domain}",
        ]
        https = false
        tls = [
          {
            hosts = [
              "argocd.${var.domain}",
            ]
          },
        ]
      }
      insecure = "true"
      replicas = 2
    }
  }

  apps_values = {
    applicationsets = [{
      name      = "bootstrap"
      namespace = "argocd"
      generators = [
        {
          git = {
            files = [
              {
                path = "./**/config.json"
              },
            ]
            repoURL  = "https://github.com/appkins-org/apps.git"
            revision = "dev"
            values = {
              name    = "{{trimSuffix \"/config.json\" .path.path | base}}"
              path    = "{{trimSuffix \"/config.json\" .path.path}}"
              project = "{{ list .path.segments | initial | initial | mustLast | default \"default\" }}"
            }
          }
        },
      ]
      goTemplate = true
      syncPolicy = {
        preserveResourcesOnDeletion = true
      }
      template = {
        metadata = {
          labels = {
            app = "{{default .values.name .name}}"
          }
          name      = "{{default .values.name .name}}"
          namespace = "argocd"
        }
        spec = {
          destination = {
            namespace = "{{default \"default\" .namespace}}"
            server    = "https://kubernetes.default.svc"
          }
          project = "{{any (empty .values.project) (eq .values.project .values.name) | ternary \"default\" .values.project}}"
          source = {
            path = "{{.values.path}}"
            plugin = {
              env = [
                {
                  name  = "ARGOCD_ENV_LOVELY_HELM_NAME"
                  value = "{{default .values.name .name}}"
                },
                {
                  name  = "ARGOCD_ENV_LOVELY_HELM_NAMESPACE"
                  value = "{{default \"default\" .namespace}}"
                },
                {
                  name  = "AVP_TYPE"
                  value = "1passwordconnect"
                },
                {
                  name  = "OP_CONNECT_TOKEN"
                  value = var.connect.token
                },
                {
                  name  = "OP_CONNECT_HOST"
                  value = var.connect.host
                }
              ]
              name = "lovely-vault-plugin"
            }
            repoURL        = "https://github.com/appkins-org/apps.git"
            targetRevision = "dev"
          }
          syncPolicy = {
            automated = {
              allowEmpty = true
              prune      = true
              selfHeal   = true
            }
            syncOptions = [
              "CreateNamespace=true",
              "Replace={{default \"false\" .replace}}"
            ]
          }
        }
      }
    }]
    extensions = [{
      name      = "argocd-appset-ext"
      namespace = "argocd"
      sources = [
        { web = { url = "https://raw.githubusercontent.com/speedfl/argocd-apps-of-applicationset/master/ui/dist/extension.tar" } }
      ]
    }]
  }
}
