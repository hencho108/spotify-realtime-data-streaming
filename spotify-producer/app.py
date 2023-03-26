import json
import os
from time import sleep

import boto3
import spotipy
from spotipy.oauth2 import SpotifyOAuth

from kafka import KafkaProducer


def read_parameter_from_ssm(parameter_name):
    """Retrieve parameters from Systems Manager Parameter Store"""
    ssm = boto3.client("ssm")
    response = ssm.get_parameter(
        Name="/spotify-streaming/" + parameter_name, WithDecryption=True
    )
    return response["Parameter"]["Value"]


def instantiate_spotify_client():
    client_id = read_parameter_from_ssm("client_id")
    client_secret = read_parameter_from_ssm("client_secret")
    redirect_uri = read_parameter_from_ssm("redirect_uri")
    print("spotify client_id, client_secret, redirect_uri")
    print(client_id, client_secret, redirect_uri)

    sp = spotipy.Spotify(
        auth_manager=SpotifyOAuth(
            client_id=client_id,
            client_secret=client_secret,
            redirect_uri=redirect_uri,
            scope="user-read-playback-state",
            open_browser=False,
        )
    )
    return sp


def main():
    print("Starting Spotify Producer...")
    sp = instantiate_spotify_client()

    # producer = KafkaProducer(
    #     bootstrap_servers=["localhost:9092"],
    #     value_serializer=lambda x: json.dumps(x).encode("utf-8"),
    # )

    previous_song_id = None

    while True:
        current_track = sp.current_playback()
        if current_track:
            artists = current_track["item"]["artists"]
            first_artist = current_track["item"]["artists"][0]["name"]
            song_name = current_track["item"]["name"]
            song_id = current_track["item"]["id"]

            if song_id != previous_song_id:
                previous_song_id = song_id
                # print(f"Playing {song_name} by {first_artist} - {song_id}")
                print(f"Playing {song_name} by {artists}")

                data = {
                    "song_name": song_name,
                    "first_artist": first_artist,
                    "artistis": artists,
                }
        # producer.send("spotify-stream", value="test test test")
        # producer.send("spotify-stream", value=data)
        # producer.flush()
        sleep(5)


if __name__ == "__main__":
    main()
