awsadm() {
   aws-vault exec ro-admin -- "$@"
}
awsid() {
   AWS_MFA_SERIAL="arn:aws:iam::139186857668:mfa/robertbrennan" aws-vault exec ro-identity -- "$@"
}
awsidk() {
  awsid kubectl "$@"
}

