const csv = require('csvtojson');
const fs = require('fs');
const {checkBool} = require('./utils');
const moment = require('moment');
const {uniqBy} = require('lodash')

csv({
    ignoreColumns: /#/
})
.fromFile('./csv/bugs-south.csv')
.then((southBugs) => {
    return csv({
        ignoreColumns: /#/
    })
    .fromFile('./csv/bugs-north.csv')
    .then((bugs)=> {
        return bugs.map((bug, i) => ({
            id: parseInt(bug["Internal ID"]),
            name: bug.Name,
            image: null,
            houseImage: `https://storage.googleapis.com/acdb/bugs/${bug["Item Filename"]}.png`,
            sell: parseInt(bug.Sell, 10),
            weather: bug.Weather,
            location: bug['Where/How'],
            rarity: bug.Rarity,
            allDay: bug["Start Time"] === 'All day',
            startTime: bug["Start Time"] === 'All day' ? null : moment(bug["Start Time"], "h:mm:ss A").utc().format(),
            endTime: bug["Start Time"] === 'All day' ? null : moment(bug["End Time"], "h:mm:ss A").utc().format(),
            northAvailableMonths: [
                checkBool(bug.Jan) ? 1 : undefined,
                checkBool(bug.Feb) ? 2 : undefined,
                checkBool(bug.Mar) ? 3 : undefined,
                checkBool(bug.Apr) ? 4 : undefined,
                checkBool(bug.May) ? 5 : undefined,
                checkBool(bug.Jun) ? 6 : undefined,
                checkBool(bug.Jul) ? 7 : undefined,
                checkBool(bug.Aug) ? 8 : undefined,
                checkBool(bug.Sep) ? 9 : undefined,
                checkBool(bug.Oct) ? 10 : undefined,
                checkBool(bug.Nov) ? 11 : undefined,
                checkBool(bug.Dec) ? 12 : undefined,
            ].filter((o) => o),
            southAvailableMonths: [
                checkBool(southBugs[i].Jan) ? 1 : undefined,
                checkBool(southBugs[i].Feb) ? 2 : undefined,
                checkBool(southBugs[i].Mar) ? 3 : undefined,
                checkBool(southBugs[i].Apr) ? 4 : undefined,
                checkBool(southBugs[i].May) ? 5 : undefined,
                checkBool(southBugs[i].Jun) ? 6 : undefined,
                checkBool(southBugs[i].Jul) ? 7 : undefined,
                checkBool(southBugs[i].Aug) ? 8 : undefined,
                checkBool(southBugs[i].Sep) ? 9 : undefined,
                checkBool(southBugs[i].Oct) ? 10 : undefined,
                checkBool(southBugs[i].Nov) ? 11 : undefined,
                checkBool(southBugs[i].Dec) ? 12 : undefined,
            ].filter((o) => o),
        })) 
    })
})
.then(json => {
    let data = JSON.stringify(json);
    fs.writeFileSync('./output/bugs.json', data);
})

csv({
    ignoreColumns: /#/
})
.fromFile('./csv/fish-south.csv')
.then((southFishes) => {
    return csv({
        ignoreColumns: /#/
    })
    .fromFile('./csv/fish-north.csv')
    .then((fishes)=> {
        return fishes.map((fish, i) => ({
            shadowSize: fish.Shadow,

            // common critter
            id: parseInt(fish["Internal ID"], 10),
            name: fish.Name,
            houseImage: `https://storage.googleapis.com/acdb/fish/${fish["Item Filename"]}.png`,
            sell: parseInt(fish.Sell, 10),
            weather: fish["Rain/Snow Catch Up"] == 'Yes' ? 'Rain or Snow' : 'Any weather',
            location: fish['Where/How'],
            rarity: fish.Rarity,
            allDay: fish["Start Time"] === 'All day',
            startTime: fish["Start Time"] === 'All day' ? null : moment(fish["Start Time"], "h:mm:ss A").utc().format(),
            endTime: fish["Start Time"] === 'All day' ? null : moment(fish["End Time"], "h:mm:ss A").utc().format(),
            northAvailableMonths: [
                checkBool(fish.Jan) ? 1 : undefined,
                checkBool(fish.Feb) ? 2 : undefined,
                checkBool(fish.Mar) ? 3 : undefined,
                checkBool(fish.Apr) ? 4 : undefined,
                checkBool(fish.May) ? 5 : undefined,
                checkBool(fish.Jun) ? 6 : undefined,
                checkBool(fish.Jul) ? 7 : undefined,
                checkBool(fish.Aug) ? 8 : undefined,
                checkBool(fish.Sep) ? 9 : undefined,
                checkBool(fish.Oct) ? 10 : undefined,
                checkBool(fish.Nov) ? 11 : undefined,
                checkBool(fish.Dec) ? 12 : undefined,
            ].filter((o) => o),
            southAvailableMonths: [
                checkBool(southFishes[i].Jan) ? 1 : undefined,
                checkBool(southFishes[i].Feb) ? 2 : undefined,
                checkBool(southFishes[i].Mar) ? 3 : undefined,
                checkBool(southFishes[i].Apr) ? 4 : undefined,
                checkBool(southFishes[i].May) ? 5 : undefined,
                checkBool(southFishes[i].Jun) ? 6 : undefined,
                checkBool(southFishes[i].Jul) ? 7 : undefined,
                checkBool(southFishes[i].Aug) ? 8 : undefined,
                checkBool(southFishes[i].Sep) ? 9 : undefined,
                checkBool(southFishes[i].Oct) ? 10 : undefined,
                checkBool(southFishes[i].Nov) ? 11 : undefined,
                checkBool(southFishes[i].Dec) ? 12 : undefined,
            ].filter((o) => o),
        })) 
    })
})
.then(json => {
    let data = JSON.stringify(json);
    fs.writeFileSync('./output/fish.json', data);
})
