-- 
-- https://github.com/fluent/fluent-bit/issues/1499
-- 

cjson = require("cjson")

cache = {}
containerz = os.getenv("CONTAINERS_PATH")

local function get_metadata(container_id)
    -- Read config file
    local config_file_path = CONTAINERS_PATH .. "/" .. container_id .. "/config.v2.json"
    local config_file = io.open(config_file_path, "rb")
    if not config_file then
        io.write(string.format("no config file for %s\n",container_id))
        return nil
    end
    local config_json = config_file:read("*a")
    config_file:close()

    -- Map json config
    local config = cjson.decode(config_json)
    io.write(string.format("container %s name %s\n",container_id, name))
    return {
        id = config.ID,
        name = config.Name:gsub("^/", ""),
        hostname = config.Config.Hostname,
        image = config.Config.Image,
        image_id = config.Image,
        labels = config.Config.Labels
    }
end

function enrich(tag, timestamp, record)
    -- Get container id from tag
    local container_id = tag:match("docker%.(.+)")
    io.write(string.format("enrich %s container id\n",tag,container_id))

    if not container_id then
        return 0, timestamp, record
    end

    -- Get metadata from cache or config
    local metadata = cache[container_id]
    if not metadata then
        metadata = get_metadata(container_id)
        if metadata then
            cache[container_id] = metadata
        end
    end

    if metadata then
        record.docker = metadata
    end

    return 2, timestamp, record
end