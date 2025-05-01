-- список всіх дітей разом із закладом та напрямом навчання
SELECT 
    c.child_id,
    c.first_name,
    c.last_name,
    i.institution_name,
    i.institution_type,
    cl.class_name,
    cl.direction
FROM Children c
JOIN Institutions i ON c.institution_id = i.institution_id
JOIN Classes cl ON c.class_id = cl.class_id
ORDER BY c.last_name, c.first_name;

-- інформація про батьків і їхніх дітей разом із вартістю навчання
SELECT 
    p.parent_id,
    p.first_name AS parent_first_name,
    p.last_name AS parent_last_name,
    c.first_name AS child_first_name,
    c.last_name AS child_last_name,
    p.tuition_fee
FROM Parents p
JOIN Children c ON p.child_id = c.child_id
ORDER BY p.last_name, p.first_name;

-- список всіх закладів з адресами та кількістю дітей
SELECT 
    i.institution_id,
    i.institution_name,
    i.institution_type,
    i.address,
    COUNT(c.child_id) AS number_of_children
FROM Institutions i
LEFT JOIN Children c ON i.institution_id = c.institution_id
GROUP BY i.institution_id, i.institution_name, i.institution_type, i.address
ORDER BY number_of_children DESC;