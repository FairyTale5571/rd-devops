#!/bin/bash

echo "🧹 Очищення Falco ресурсів..."

echo "📦 Видалення Falco компонентів..."
kubectl delete daemonset falco -n kube-system --ignore-not-found=true
kubectl delete configmap falco-config -n kube-system --ignore-not-found=true
kubectl delete serviceaccount falco -n kube-system --ignore-not-found=true
kubectl delete clusterrole falco --ignore-not-found=true
kubectl delete clusterrolebinding falco --ignore-not-found=true

echo ""
echo "✅ Очищення завершено!"