-- SQLite
INSERT INTO operations (
    date,
    time,
    operation_type,
    transaction_type,
    numero_facture,
    montant,
    montant_verse,
    montant_deductible,
    commission_CMI,
    benefice,
    benefice_supplementaire,
    solde_avant,
    solde_apres,
    remarque
)
VALUES 
-- 2026-08-10
('2026-08-10', '09:00:00', 'TRANSACTION', 'NATIONALE',
 1001, 5000.000, 4900.000, 100.000, 50.000, 50.000, 10.000,
 20000.000, 15100.000, 'Transaction nationale'),

('2026-08-10', '11:30:00', 'TRANSACTION', 'INTERNATIONALE',
 1002, 8000.000, 7784.000, 216.000, 216.000, 0.000, 0.000,
 15100.000, 7316.000, 'Transaction internationale'),

('2026-08-10', '15:00:00', 'FOURNITURE', NULL,
 2001, 1500.000, 0.000, 0.000, 0.000, 0.000, 0.000,
 7316.000, 5816.000, 'Achat fourniture'),

-- 2026-08-11
('2026-08-11', '08:45:00', 'TRANSACTION', 'NATIONALE',
 1003, 3000.000, 2940.000, 60.000, 30.000, 30.000, 5.000,
 5816.000, 2876.000, 'Transaction nationale'),

('2026-08-11', '13:20:00', 'TRANSACTION', 'NATIONALE',
 1004, 4500.000, 4410.000, 90.000, 45.000, 45.000, 7.500,
 2876.000, -1534.000, 'Deuxième transaction'),

('2026-08-11', '16:10:00', 'FOURNITURE', NULL,
 2002, 750.000, 0.000, 0.000, 0.000, 0.000, 0.000,
 -1534.000, -2284.000, 'Fourniture bureau'),

-- 2026-08-12
('2026-08-12', '09:15:00', 'TRANSACTION', 'INTERNATIONALE',
 1005, 10000.000, 9730.000, 270.000, 270.000, 0.000, 0.000,
 -2284.000, -12014.000, 'Transaction internationale'),

('2026-08-12', '14:40:00', 'TRANSACTION', 'NATIONALE',
 1006, 2500.000, 2450.000, 50.000, 25.000, 25.000, 4.000,
 -12014.000, -14464.000, 'Transaction nationale'),

-- Exemple de ligne supprimée logiquement
('2026-08-12', '17:00:00', 'FOURNITURE', NULL,
 2003, 1200.000, 0.000, 0.000, 0.000, 0.000, 0.000,
 -14464.000, -15664.000, 'Fourniture supprimée');



INSERT INTO bilan_quotidien (
    date,
    numero_facture,
    total_montant_verse,
    total_benefice,
    total_benefice_supplementaire,
    total_commission_CMI,
    total_montant_deductible,
    total_montant
)
VALUES
('2026-08-10', 1002,
 12684.000,
 50.000,
 10.000,
 266.000,
 316.000,
 13000.000),

('2026-08-11', 1004,
 7350.000,
 75.000,
 12.500,
 75.000,
 150.000,
 7500.000),

('2026-08-12', 1006,
 12180.000,
 25.000,
 4.000,
 295.000,
 320.000,
 12500.000);