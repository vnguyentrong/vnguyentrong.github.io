#!/bin/bash

CURR_DIR=$(dirname "$(realpath "$0")")

date_post=$(date +"%Y-%m-%d")
time_post=$(date +"%I:%M %p %Z")
# time_post=$(date +"%H:%M:%S %Z")

# Directory to store posts
POST_DIR="${CURR_DIR}/../_posts"
POST_ASSET_DIR="${POST_DIR}/assets"
# POST_ASSET="${POST_DIR}"

###################################### INTERNAL ######################################
POST_INFO_START="---"
POST_TITLE="title: \"topic: input_your_title\""
POST_DES="description: >-"
POST_DES_CONTENT="  input_description"
# POST_AUT="author: vnguyentrong"
POST_TIME="date: ${date_post} ${time_post}"
POST_CAT="categories: [input_post_categories]"
POST_TAG="tags: [input_tags,,]"
POST_ASSET_FIELD="post_asset: https://github.com/vnguyentrong/vnguyentrong.github.io/blob/icode_master/_posts/assets"
POST_INFO_END="---"

POST_SESSION="##"

decorate_post_template () {
    local post=$1
    local post_file="${POST_DIR}/${post}.md"
    echo $post_file

    # post info
    echo $POST_INFO_START >> $post_file
    echo $POST_TITLE >> $post_file
    echo $POST_DES >> $post_file
    echo $POST_DES_CONTENT >> $post_file
    # echo $POST_AUT >> $post_file
    echo $POST_TIME >> $post_file
    echo $POST_CAT >> $post_file
    echo $POST_TAG >> $post_file
    echo "${POST_ASSET_FIELD}/${post}" >> $post_file
    echo $POST_INFO_END >> $post_file

    # post content
    echo "" >> $post_file
    echo $POST_SESSION >> $post_file
    echo "" >> $post_file
    echo "" >> $post_file
    echo $POST_SESSION >> $post_file

    echo "" >> $post_file
    echo "" >> $post_file

}

###################################### INTERFACE ######################################
# Function to display help message
help() {
    echo "usages:"
    echo "# create a post with title"
    echo "      ./template_generator.sh -c <post_title>"
    echo "# list available posts"
    echo "      ./template_generator.sh -l"
    echo "# remove a post"
    echo "      ./template_generator.sh -r <post_title>"
}

# Function to create a post
create_post() {
    local post="$1"
    local post_file="${POST_DIR}/${post}.md"
    local post_asset_dir="${POST_ASSET_DIR}/${post}"

    if [[ -f "$post_file" ]]; then
        echo "Post '${post}' already exists."
    else
        mkdir -p $post_asset_dir
        touch "$post_file"
        decorate_post_template "$post"
        echo "Post '${post}' created."
    fi
}

# list available posts
list_posts() {
    if [[ -d "$POST_DIR" ]]; then
        local posts=$(ls "$POST_DIR")
        if [[ -z "$posts" ]]; then
            echo "No posts available."
        else
            for post in $posts; do
                if [[ $post == "assets" ]]; then
                    continue
                fi
                echo "${post%.md}"
            done
        fi
    else
        echo "No posts available."
    fi
}

# remove a post
remove_post() {
    local post="$1"
    local post_file="${POST_DIR}/${post}.md"
    local post_asset_dir="${POST_ASSET_DIR}/${post}"

    if [[ -f "$post_file" ]]; then
        rm "$post_file"
        rm -r "$post_asset_dir"
        echo "Post '${post}' removed."
    else
        echo "Post '${post}' does not exist."
    fi
}

# Main script logic
if [[ $# -eq 0 ]]; then
    help
    exit 1
fi

case "$1" in
    -c)
        if [[ -z "$2" ]]; then
            echo "Please provide a post title to create."
            exit 1
        fi
        created_post="${date_post}-$2"
        create_post "$created_post"
        ;;
    -l)
        list_posts
        ;;
    -r)
        if [[ -z "$2" ]]; then
            echo "Please provide a post title to remove."
            exit 1
        fi
        remove_post "$2"
        ;;
    *)
        help
        ;;
esac


