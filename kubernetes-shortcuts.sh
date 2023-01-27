alias k=kubectl

# Autocomplete for K8s https://github.com/kubernetes/kubectl/issues/120
complete -o default -F __start_kubectl k

alias kcv='k config view'
alias kcgc='k config get-contexts'
alias kccc='k config current-context'
alias kgs='k get services'
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

# K8s Staging
alias k8stg='tsh login --auth=okta --proxy=tele.spoton.sh staging'

# K8s Production
alias k8sprd='tsh login --auth=okta --proxy=tele.spoton.sh prod'


echo "Shared Environment: Kubnetes shortcuts loaded."

