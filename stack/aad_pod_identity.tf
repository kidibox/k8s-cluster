resource "kubernetes_manifest" "serviceaccount_aad_pod_id_nmi_service_account" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "name" = "aad-pod-id-nmi-service-account"
      "namespace" = "default"
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_azureassignedidentities_aadpodidentity_k8s_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "name" = "azureassignedidentities.aadpodidentity.k8s.io"
    }
    "spec" = {
      "group" = "aadpodidentity.k8s.io"
      "names" = {
        "kind" = "AzureAssignedIdentity"
        "plural" = "azureassignedidentities"
      }
      "scope" = "Namespaced"
      "version" = "v1"
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_azureidentitybindings_aadpodidentity_k8s_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "name" = "azureidentitybindings.aadpodidentity.k8s.io"
    }
    "spec" = {
      "group" = "aadpodidentity.k8s.io"
      "names" = {
        "kind" = "AzureIdentityBinding"
        "plural" = "azureidentitybindings"
      }
      "scope" = "Namespaced"
      "version" = "v1"
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_azureidentities_aadpodidentity_k8s_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "name" = "azureidentities.aadpodidentity.k8s.io"
    }
    "spec" = {
      "group" = "aadpodidentity.k8s.io"
      "names" = {
        "kind" = "AzureIdentity"
        "plural" = "azureidentities"
        "singular" = "azureidentity"
      }
      "scope" = "Namespaced"
      "version" = "v1"
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_azurepodidentityexceptions_aadpodidentity_k8s_io" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1beta1"
    "kind" = "CustomResourceDefinition"
    "metadata" = {
      "name" = "azurepodidentityexceptions.aadpodidentity.k8s.io"
    }
    "spec" = {
      "group" = "aadpodidentity.k8s.io"
      "names" = {
        "kind" = "AzurePodIdentityException"
        "plural" = "azurepodidentityexceptions"
        "singular" = "azurepodidentityexception"
      }
      "scope" = "Namespaced"
      "version" = "v1"
    }
  }
}

resource "kubernetes_manifest" "clusterrole_aad_pod_id_nmi_role" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "aad-pod-id-nmi-role"
    }
    "rules" = [
      {
        "apiGroups" = [
          "apiextensions.k8s.io",
        ]
        "resources" = [
          "customresourcedefinitions",
        ]
        "verbs" = [
          "get",
          "list",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "pods",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "secrets",
        ]
        "verbs" = [
          "get",
        ]
      },
      {
        "apiGroups" = [
          "aadpodidentity.k8s.io",
        ]
        "resources" = [
          "azureidentitybindings",
          "azureidentities",
          "azurepodidentityexceptions",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "aadpodidentity.k8s.io",
        ]
        "resources" = [
          "azureassignedidentities",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_aad_pod_id_nmi_binding" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "labels" = {
        "k8s-app" = "aad-pod-id-nmi-binding"
      }
      "name" = "aad-pod-id-nmi-binding"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "aad-pod-id-nmi-role"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "aad-pod-id-nmi-service-account"
        "namespace" = "default"
      },
    ]
  }
}

resource "kubernetes_manifest" "daemonset_nmi" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "DaemonSet"
    "metadata" = {
      "labels" = {
        "component" = "nmi"
        "k8s-app" = "aad-pod-id"
        "tier" = "node"
      }
      "name" = "nmi"
      "namespace" = "default"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "component" = "nmi"
          "tier" = "node"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "component" = "nmi"
            "tier" = "node"
          }
        }
        "spec" = {
          "containers" = [
            {
              "args" = [
                "--node=$(NODE_NAME)",
                "--http-probe-port=8085",
              ]
              "env" = [
                {
                  "name" = "HOST_IP"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "status.podIP"
                    }
                  }
                },
                {
                  "name" = "NODE_NAME"
                  "valueFrom" = {
                    "fieldRef" = {
                      "fieldPath" = "spec.nodeName"
                    }
                  }
                },
              ]
              "image" = "mcr.microsoft.com/oss/azure/aad-pod-identity/nmi:v1.6.3"
              "imagePullPolicy" = "Always"
              "livenessProbe" = {
                "httpGet" = {
                  "path" = "/healthz"
                  "port" = 8085
                }
                "initialDelaySeconds" = 10
                "periodSeconds" = 5
              }
              "name" = "nmi"
              "resources" = {
                "limits" = {
                  "cpu" = "200m"
                  "memory" = "512Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "256Mi"
                }
              }
              "securityContext" = {
                "capabilities" = {
                  "add" = [
                    "NET_ADMIN",
                  ]
                }
              }
              "volumeMounts" = [
                {
                  "mountPath" = "/run/xtables.lock"
                  "name" = "iptableslock"
                },
              ]
            },
          ]
          "dnsPolicy" = "ClusterFirstWithHostNet"
          "hostNetwork" = true
          "nodeSelector" = {
            "kubernetes.io/os" = "linux"
          }
          "serviceAccountName" = "aad-pod-id-nmi-service-account"
          "volumes" = [
            {
              "hostPath" = {
                "path" = "/run/xtables.lock"
                "type" = "FileOrCreate"
              }
              "name" = "iptableslock"
            },
          ]
        }
      }
      "updateStrategy" = {
        "type" = "RollingUpdate"
      }
    }
  }
}

resource "kubernetes_manifest" "serviceaccount_aad_pod_id_mic_service_account" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "name" = "aad-pod-id-mic-service-account"
      "namespace" = "default"
    }
  }
}

resource "kubernetes_manifest" "clusterrole_aad_pod_id_mic_role" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "aad-pod-id-mic-role"
    }
    "rules" = [
      {
        "apiGroups" = [
          "apiextensions.k8s.io",
        ]
        "resources" = [
          "customresourcedefinitions",
        ]
        "verbs" = [
          "*",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "pods",
          "nodes",
        ]
        "verbs" = [
          "list",
          "watch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "events",
        ]
        "verbs" = [
          "create",
          "patch",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "configmaps",
        ]
        "verbs" = [
          "get",
          "create",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "endpoints",
        ]
        "verbs" = [
          "create",
          "get",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "aadpodidentity.k8s.io",
        ]
        "resources" = [
          "azureidentitybindings",
          "azureidentities",
        ]
        "verbs" = [
          "get",
          "list",
          "watch",
          "post",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "aadpodidentity.k8s.io",
        ]
        "resources" = [
          "azurepodidentityexceptions",
        ]
        "verbs" = [
          "list",
          "update",
        ]
      },
      {
        "apiGroups" = [
          "aadpodidentity.k8s.io",
        ]
        "resources" = [
          "azureassignedidentities",
        ]
        "verbs" = [
          "*",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrolebinding_aad_pod_id_mic_binding" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "labels" = {
        "k8s-app" = "aad-pod-id-mic-binding"
      }
      "name" = "aad-pod-id-mic-binding"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "aad-pod-id-mic-role"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "aad-pod-id-mic-service-account"
        "namespace" = "default"
      },
    ]
  }
}

resource "kubernetes_manifest" "azurepodidentityexception_mic_exception" {
  manifest = {
    "apiVersion" = "aadpodidentity.k8s.io/v1"
    "kind" = "AzurePodIdentityException"
    "metadata" = {
      "name" = "mic-exception"
      "namespace" = "default"
    }
    "spec" = {
      "podLabels" = {
        "app" = "mic"
        "component" = "mic"
      }
    }
  }
}

resource "kubernetes_manifest" "azurepodidentityexception_aks_addon_exception" {
  manifest = {
    "apiVersion" = "aadpodidentity.k8s.io/v1"
    "kind" = "AzurePodIdentityException"
    "metadata" = {
      "name" = "aks-addon-exception"
      "namespace" = "kube-system"
    }
    "spec" = {
      "podLabels" = {
        "kubernetes.azure.com/managedby" = "aks"
      }
    }
  }
}
