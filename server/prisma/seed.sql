INSERT INTO "Country"(code, name) VALUES
  ('USA','USA'),
  ('CHN','China'),
  ('DEU','Germany'),
  ('JPN','Japan'),
  ('IND','India')
ON CONFLICT (code) DO NOTHING;

INSERT INTO "Product"(code, name) VALUES
  ('STEEL','Steel'),
  ('GRAIN','Grain'),
  ('OIL','Oil'),
  ('ELEC','Electronics'),
  ('TEXT','Textiles')
ON CONFLICT (code) DO NOTHING;

INSERT INTO "AppUser"(username, role) VALUES
  ('pavan','operator')
ON CONFLICT (username) DO UPDATE SET role='operator';