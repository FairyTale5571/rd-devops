#!/bin/bash

cd ./redis-statefulset

echo "🧹 Очищення Redis ресурсів..."

if kubectl get statefulset redis &> /dev/null; then
    echo "📦 Видалення StatefulSet redis..."
    kubectl delete statefulset redis --grace-period=30
else
    echo "✓ StatefulSet redis не знайдено"
fi

if kubectl get service redis-service &> /dev/null; then
    echo "📦 Видалення Service redis-service..."
    kubectl delete service redis-service
else
    echo "✓ Service redis-service не знайдено"
fi

echo "⏳ Очікування видалення подів..."
kubectl wait --for=delete pod/redis-0 --timeout=60s 2>/dev/null || true
kubectl wait --for=delete pod/redis-1 --timeout=60s 2>/dev/null || true

echo "📦 Перевірка PVC..."
PVCS=$(kubectl get pvc -l app=redis -o name 2>/dev/null)
if [ ! -z "$PVCS" ]; then
    echo "Знайдено PVC:"
    kubectl get pvc -l app=redis
    read -p "Видалити всі PVC (дані будуть втрачені)? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        kubectl delete pvc -l app=redis
        echo "✓ PVC видалено"
    else
        echo "⚠️  PVC збережено"
    fi
else
    echo "✓ PVC не знайдено"
fi

echo ""
echo "✅ Очищення завершено!"