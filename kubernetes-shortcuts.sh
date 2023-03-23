alias k=kubectl

# Autocomplete for K8s https://github.com/kubernetes/kubectl/issues/120
complete -o default -F __start_kubectl k

alias kcv='k config view'
alias kcgc='k config get-contexts'
alias kccc='k config current-context'
alias kgs='k get services'
alias kgn='k get namespaces'
alias kgpa='k get pods --all-namespaces'
alias kgpo='k get pods -o wide'

function kubectl_config_use_context() {
    if [[ $# -eq 0 ]]; then
        echo "You must supply a context."
        return 1
    fi
    kubectl config use-context $1
}
alias kcuc='kubectl_config_use_context'

function kubectl_namespace_pods() {
    if [[ $# -eq 0 ]]; then
        echo "You must supply a namespace."
        return 1
    fi
    kubectl --namespace $1 get pods
}
alias knp='kubectl_namespace_pods'

function kubectl_exec_namespace_pod() {
    if [[ $# -eq 0 ]]; then
        echo "You must supply a namespace and a pod."
        return 1
    fi
    kubectl --namespace $1 exec -it $2 -- bash
}
alias ke='kubectl_exec_namespace_pod'




# K8s Staging
alias k8stg='tsh login --auth=okta --proxy=tele.spoton.sh staging'

# K8s Production
alias k8sprd='tsh login --auth=okta --proxy=tele.spoton.sh prod'


echo "Shared Environment: Kubnetes shortcuts loaded."

