const csv = require('csvtojson');
const fs = require('fs');
const {uniqBy} = require('lodash')
const recipes = require('./output/recipes.json');

csv()
    .fromFile(`./csv/recipes.csv`)
    .then((recipes) => {
        return recipes.map((recipe) => ({
            name: recipe.Name,
            source: recipe.Sources,
            category: recipe.Category,
            materials: [
                recipe['Material 1'].length > 0 ? { name: recipe['Material 1'], count: parseInt(recipe["#1"], 10) } : undefined, 
                recipe['Material 2'].length > 0 ? { name: recipe['Material 2'], count: parseInt(recipe["#2"], 10) } : undefined, 
                recipe['Material 3'].length > 0 ? { name: recipe['Material 3'], count: parseInt(recipe["#3"], 10) } : undefined, 
                recipe['Material 4'].length > 0 ? { name: recipe['Material 4'], count: parseInt(recipe["#4"], 10) } : undefined, 
                recipe['Material 5'].length > 0 ? { name: recipe['Material 5'], count: parseInt(recipe["#5"], 10) } : undefined, 
                recipe['Material 6'].length > 0 ? { name: recipe['Material 6'], count: parseInt(recipe["#6"], 10) } : undefined, 
            ]
            .filter(o => o)
        }))
    })
    .then(json => {
        let data = JSON.stringify(json, null, 2);
        fs.writeFileSync(`./output/recipes.json`, data);

        const house = ['housewares', 'miscellaneous', 'wall-mounted', 'wallpapers', 'floors', 'rugs']
        house.map((k) => {
            csv()
            .fromFile(`./csv/${k}.csv`)
            .then((items) => {
            return items.map((item) => ({
                id: parseInt(item["Internal ID"], 10),
                name: item.Name,
                details: item["Source Notes"].length > 0 ? item["Source Notes"] : null,
                source: item.Source,
                diy: item.DIY === 'Yes' ? true : false,
                buy: parseInt(item.Buy, 10),
                sell: parseInt(item.Sell, 10),
                colors: [item["Color 1"], item["Color 2"]].filter(o => o),
                hhaConcepts: [item["HHA Concept 1"], item["HHA Concept 2"]].filter(o => o),
                variants: [items.filter(o => o.Name === item.Name).map(o => ({
                    id: parseInt(o["Internal ID"], 10),
                    name: o.Variation,
                    image: `https://storage.googleapis.com/acdb/${k}/${o.Filename}.png`,
                    colors: [o["Color 1"], o["Color 2"]].filter(o => o),
                }))],
                recipe: item.DIY === 'Yes' ? recipes.filter(o => o.name === item.Name).pop() : null,
                size: item.Size,
                tag: item.Tag
            })) 
        })
        .then(json => {
            let data = JSON.stringify(uniqBy(json, 'id'));
            fs.writeFileSync(`./output/${k}.json`, data);
        })
        })

        const items = [
        'accessories', 
        'bags', 
        'headwear', 
        'tops', 
        'bottoms', 
        'dresses', 
        'socks', 
        'shoes', 
        'umbrellas', 
        'tools', 
        'other', 
        'fossils', 
        'music', 
        'posters', 
        'photos', 
        'fencing'
        ]
        items.map(k => {
        csv()
        .fromFile(`./csv/${k}.csv`)
        .then((items) => {
            return items.map((item) => ({
                id: parseInt(item["Internal ID"], 10),
                name: item.Name,
                details: item["Source Notes"] && item["Source Notes"].length > 0 ? item["Source Notes"] : null,
                source: item.Source,
                diy: item.DIY === 'Yes' ? true : false,
                buy: parseInt(item.Buy, 10),
                sell: parseInt(item.Sell, 10),
                colors: [item["Color 1"], item["Color 2"]].filter(o => o),
                variants: [items.filter(o => o.Name === item.Name).map(o => ({
                    id: parseInt(o["Internal ID"], 10),
                    name: o.Variation,
                    image: `https://storage.googleapis.com/acdb/${k}/${o.Filename}.png`,
                    colors: [o["Color 1"], o["Color 2"]].filter(o => o),
                }))],
                recipe: item.DIY === 'Yes' ? recipes.filter(o => o.name === item.Name).pop() : null,
                size: item.Size,
                tag: item.Tag
            })) 
        })
        .then(json => {
            let data = JSON.stringify(uniqBy(json, 'id'));
            fs.writeFileSync(`./output/${k}.json`, data);
        })
        })
    })
