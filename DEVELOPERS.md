# Some advices for developers 


## Encoding issues

Be attentive with encoding and wide characters: 

https://habrahabr.ru/post/53578/

http://www.nestor.minsk.by/sr/2008/09/sr80902.html


## Mongo DB geo queries

```
db.cmits.createIndex({ longlat: "2dsphere" });


db.cmits.aggregate([{
  $geoNear: {
    near: {
      type: "Point",
      coordinates: [47.23317, 39.716848]
    },
    distanceField: "dist.calculated",
    query: {
      type: "public"
    },
    includeLocs: "longlat",
    num: 5,
    spherical: true
  }
}])

db.cmits.find({ location : { $near : [ 47.23317, 39.716848 ] } })

db.cmits.drop()

```


## Typical errors

If you see ```Use of uninitialized value``` error - check that you are calling methods inside module as $self->method_name, not method_name()

