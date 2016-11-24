
WebTorrent = require 'webtorrent-hybrid'
parseTorrent = require 'parse-torrent'
request = require '../request'
Media = require '../media'

exports.lookup = (id) ->
    try parseTorrent(id)
    catch e
        throw new Error("Invalid torrent");

    client = new WebTorrent();
    client.add(id,(torrent) ->
        for i,f of torrent.files
            file = null
            file = f if f.name.endsWidth(".mp4")

            if file is null
                continue

            file.getBlobURL((err, url) ->
                throw new Error(err) if err
                return new Media(
                    id: id
                    title: file.name || "torrent-file"
                    duration: 0
                    type: 'webtorrent'
                    meta:
                        direct:
                            1080: [{
                                url:url
                                contentType:'video/mp4'
                            }]
                            720: [{
                                url:url
                                contentType:'video/mp4'
                            }]
                            480: [{
                                url:url
                                contentType:'video/mp4'
                            }]
                            360: [{
                                url:url
                                contentType:'video/mp4'
                            }]

                )
            )
    )
exports.parseUrl = (url) ->
    try torrent = parseTorrent(url)
    catch e
        throw new Error(e)

    return {
        type:'webtorrent'
        kind:'single'
        id:torrent.infoHash
    }
