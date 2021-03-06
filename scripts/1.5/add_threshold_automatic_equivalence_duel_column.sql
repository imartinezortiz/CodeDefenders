/* Add "EquivalenceThreshold" column to games. */
ALTER TABLE games ADD EquivalenceThreshold INT(11) DEFAULT 0 NOT NULL;

/* Update game views */
CREATE OR REPLACE VIEW `view_battleground_games` AS
SELECT games.*, classes.Name, classes.JavaFile, classes.ClassFile, classes.Alias, classes.RequireMocking, classes.Active
FROM games,
     classes
WHERE Mode = 'PARTY'
  AND games.Class_ID = classes.Class_ID;

CREATE OR REPLACE VIEW `view_puzzle_games` AS
SELECT games.*, classes.Name, classes.JavaFile, classes.ClassFile, classes.Alias, classes.RequireMocking, classes.Active
FROM games,
     classes
WHERE Mode = 'PUZZLE'
  AND games.Class_ID = classes.Class_ID;