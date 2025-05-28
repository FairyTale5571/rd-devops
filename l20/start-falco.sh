#!/bin/bash

cd ./falco-daemonset

echo "🚀 Розгортання Falco DaemonSet..."
echo ""

if [ ! -f "falco-daemonset.yaml" ]; then
    echo "❌ Помилка: Не знайдено falco-daemonset.yaml!"
    exit 1
fi

echo "📦 Створення Falco ресурсів..."
if kubectl apply -f falco-daemonset.yaml; then
    echo "✓ Ресурси створено успішно"
else
    echo "❌ Помилка створення ресурсів"
    exit 1
fi

echo ""
echo "⏳ Очікування запуску Falco..."
sleep 5

echo "📊 Статус DaemonSet:"
kubectl get daemonset falco -n kube-system


echo ""
echo "📊 Статус подів:"
kubectl get pods -l app=falco -n kube-system

echo ""
echo "⏳ Очікування готовності Falco..."
FALCO_POD=$(kubectl get pods -l app=falco -n kube-system -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ ! -z "$FALCO_POD" ]; then
    echo "Очікування готовності $FALCO_POD..."
    if kubectl wait --for=condition=ready pod/$FALCO_POD -n kube-system --timeout=120s; then
        echo "✓ Falco готовий"
    else
        echo "⚠️  Falco не готовий, перевірте логи"
    fi
else
    echo "⚠️  Под Falco не знайдено"
fi

echo ""
echo "✅ Розгортання завершено!"
echo ""
echo "🔧 Корисні команди:"
echo "  - Перегляд логів: kubectl logs -l app=falco -n kube-system"
echo "  - Слідкувати за логами: kubectl logs -l app=falco -n kube-system -f"
echo "  - Статус DaemonSet: kubectl describe daemonset falco -n kube-system"
echo "  - Видалити Falco: kubectl delete -f falco-daemonset.yaml"