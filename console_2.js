

db.comics.find(
    { price: { $lt: 10 } },
    { title: 1, description: 1, price: 1, category: 1, _id: 0 }
).sort({ title: 1 });

db.characterxpower.aggregate([
    {
        $match: { powerId: 1 }
    },
    {
        $lookup: {
            from: "characters",
            localField: "characterId",
            foreignField: "_id",
            as: "characterDetails"
        }
    },

    {
        $project: {
            _id: 1,
            hero_name: "$characterDetails.name"
        }
    }
]);



//
db.characters.find(
    { type: "Villain", defeats: { $gt: 3 } },
    { name: 1, defeats: 1, _id: 0 }
).sort({ defeats: -1 });


db.transactions.aggregate([
    {
        $lookup: {
            from: "comics",
            localField: "comicId",
            foreignField: "_id",
            as: "comicDetails"
        }
    },
    {
        $lookup: {
            from: "categories",
            localField: "comicDetails.category",
            foreignField: "_id",
            as: "categoryDetails"
        }
    },
    {
        $group: {
            _id: "$categoryDetails.name",
            purchase_count: { $sum: 1 }
        }
    },
    {
        $sort: { purchase_count: -1 }
    },
    {
        $limit: 1
    }
]);



db.comics.aggregate([
    {
        $match: {
            category: 4
        }
    },
    {
        $lookup: {
            from: "characters",
            localField: "_id",
            foreignField: "_id",
            as: "characterDetails"
        }
    },
    {
        $lookup: {
            from: "weapons",
            localField: "characterDetails._id",
            foreignField: "characterId",
            as: "weaponDetails"
        }
    },
    {
        $match: {
            "weaponDetails.name": "Batmobile"
        }
    },
    {
        $project: {
            _id: 1,
            title: 1
        }
    }
]);





