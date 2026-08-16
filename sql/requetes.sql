CREATE TABLE IF NOT EXISTS operations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    date DATE NOT NULL DEFAULT CURRENT_DATE,
    time TIME NOT NULL DEFAULT CURRENT_TIME,

    operation_type TEXT NOT NULL
        CHECK (operation_type IN ('TRANSACTION', 'FOURNITURE')),

    transaction_type TEXT
        CHECK (
            transaction_type IS NULL
            OR transaction_type IN ('NATIONALE', 'INTERNATIONALE')
        ),
    numero_facture INTEGER,
    montant DECIMAL(10, 3) NOT NULL,
    montant_verse DECIMAL(10, 3) NOT NULL DEFAULT 0,
    montant_deducti ble DECIMAL(10, 3) NOT NULL DEFAULT 0,
    commission_CMI DECIMAL(10, 3) NOT NULL DEFAULT 0,
    benefice DECIMAL(10, 3) NOT NULL DEFAULT 0,
    benefice_supplementaire DECIMAL(10, 3) NOT NULL DEFAULT 0,

    solde_avant DECIMAL(10, 3) NOT NULL,
    solde_apres DECIMAL(10, 3) NOT NULL,

    remarque TEXT,

    supprime BOOLEAN NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS bilan_quotidien (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    numero_facture INTEGER,
    total_montant_verse DECIMAL(10, 3) NOT NULL DEFAULT 0,
    total_benefice DECIMAL(10, 3) NOT NULL DEFAULT 0,
    total_benefice_supplementaire DECIMAL(10, 3) NOT NULL DEFAULT 0,
    total_commission_CMI DECIMAL(10, 3) NOT NULL DEFAULT 0,
    total_montant_deductible DECIMAL(10, 3) NOT NULL DEFAULT 0,
    total_montant DECIMAL(10, 3) NOT NULL DEFAULT 0
    );
