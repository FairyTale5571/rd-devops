#!/bin/bash

cd ./redis-statefulset

echo "🚀 Розгортання Redis кластера..."
echo ""

if [ ! -f "redis-service.yaml" ] || [ ! -f "redis-statefulset.yaml" ]; then
    echo "❌ Помилка: Не знайдено необхідні YAML файли!"
    echo "Переконайтеся, що redis-service.yaml та redis-statefulset.yaml знаходяться в поточній директорії."
    exit 1
fi

echo "📦 Створення Service..."
if kubectl apply -f redis-service.yaml; then
    echo "✓ Service створено успішно"
else
    echo "❌ Помилка створення Service"
    exit 1
fi

echo "📦 Створення StatefulSet..."
if kubectl apply -f redis-statefulset.yaml; then
    echo "✓ StatefulSet створено успішно"
else
    echo "❌ Помилка створення StatefulSet"
    exit 1
fi

echo ""
echo "⏳ Очікування запуску подів..."
echo "Це може зайняти кілька хвилин..."

for i in 0 1; do
    echo -n "Очікування redis-$i... "
    if kubectl wait --for=condition=ready pod/redis-$i --timeout=120s; then
        echo "✓"
    else
        echo "❌"
        echo "Под redis-$i не готовий. Перевірте логи: kubectl logs redis-$i"
    fi
done

echo ""
echo "📊 Статус розгортання:"
kubectl get statefulset redis
echo ""
kubectl get pods -l app=redis -o wide
echo ""
kubectl get pvc -l app=redis

echo ""
echo "✅ Розгортання завершено!"
echo ""
echo "🔧 Корисні команди:"
echo "  - Підключення до Redis: kubectl exec -it redis-0 -- redis-cli"
echo "  - Перегляд логів: kubectl logs redis-0"
echo "  - Статус подів: kubectl get pods -l app=redis"