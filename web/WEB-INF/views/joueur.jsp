<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Enregistrement réussi</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f6fa; }
        .card {
            max-width: 520px;
            margin: 0 auto;
            background: #fff;
            padding: 24px;
            border-radius: 10px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.08);
        }
        .title { font-size: 20px; font-weight: 700; margin-bottom: 18px; color: #1f7a1f; }
        .row { margin: 10px 0; }
        .label { font-weight: 700; display: inline-block; min-width: 140px; }
        .actions { margin-top: 18px; }
        a.btn {
            display: inline-block;
            padding: 10px 14px;
            background: #2c7be5;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
        }
        a.btn:hover { background: #1a5fc4; }
    </style>
</head>
<body>

<div class="card">
    <div class="title">✅ Joueur enregistré avec succès</div>

    <h3>Récapitulatif</h3>

    <div class="row">
        <span class="label">Nom & prenom :</span>
        <span>${joueur.nom} ${joueur.prenom}</span>
    </div>   

    <div class="row">
        <span class="label">Poste :</span>
        <span>${joueur.poste}</span>
    </div>

    <div class="row">
        <span class="label">Âge :</span>
        <span>${joueur.age} ans</span>
    </div>    
</div>

</body>
</html>
