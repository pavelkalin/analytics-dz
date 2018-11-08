/*
подключиться к Mongo из командной строки Linux и загрузить в Mongo текстовый JSON-файл;

/usr/bin/mongoimport --host $APP_MONGO_HOST --port $APP_MONGO_PORT --db movies --collection tags --file /data/simple_tags.json
 */
/*
        Написать запрос, который выводит общее число тегов
*/
print("tags count: ", db.tags.count());
/*
        Добавляем фильтрацию: считаем только количество тегов woman
*/
print("woman tags count: ", db.tags.find({name: 'woman'}).count());
/*
        Очень сложный запрос: используем группировку данных посчитать количество вхождений для каждого тега
        и напечатать top-3 самых популярных
        используя группировку данных ($groupby) вывести top-3 самых распространённых тегов
*/

printjson(
    db.tags.aggregate([
 { "$group": {
        "_id": null,
        "name": { "$push": "$name" }

    }},
    { "$unwind": "$name" },
    { "$group": {
        "_id": "$name",
        "count": { "$sum": 1  }
    }},
    { "$sort": { "count": -1 } },{$limit: 3}])['_batch']
);

