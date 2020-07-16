import asyncio
import discord
import subprocess

client = discord.Client()

def process_message(message):
    args = message.content.split(' ')
    return args

@client.event
async def on_message(message):
    if message.author == client.user:
        return

    if message.content.startswith('!commands') and message.channel.id == '390502114884845569':
        msg = '```● available commands for #uploading:\n  !final <url>\n  !mapcheck <url>\n  !restart\n  !upload <url>```'
        await client.send_message(message.channel, msg)

    if message.content.startswith('!final') and message.channel.id == '390502114884845569':
        args = process_message(message)
        url = args[1]
        sco = subprocess.check_output(['./final.sh', url], universal_newlines=True)
        msg = '```{}```'.format(sco)
        await client.send_message(message.channel, msg)

    if message.content.startswith('!mapcheck') and message.channel.id == '390502114884845569':
        args = process_message(message)
        url = args[1]
        sco = subprocess.check_output(['./mapcheck.sh', url], universal_newlines=True)
        msg = '```{}```'.format(sco)
        await client.send_message(message.channel, msg)

    if message.content.startswith('!restart') and message.channel.id == '390502114884845569':
        sco = subprocess.check_output(['./restart.sh'], universal_newlines=True)
        msg = '```{}```'.format(sco)
        await client.send_message(message.channel, msg)

    if message.content.startswith('!upload') and message.channel.id == '390502114884845569':
        args = process_message(message)
        url = args[1]
        sco = subprocess.check_output(['./upload.sh', url], universal_newlines=True)
        msg = '```{}```'.format(sco)
        await client.send_message(message.channel, msg)

    if not message.attachments and not message.content.startswith('!commands') and not message.content.startswith('!final') and not message.content.startswith('!mapcheck') and not message.content.startswith('!restart') and not message.content.startswith('!upload'):
        if message.channel.id == '390502114884845569':
            msg = '```● use #maps channel for map related stuff\n● available commands for #uploading:\n  !final <url>\n  !mapcheck <url>\n  !restart\n  !upload <url>```'
            await client.delete_message(message)
            await client.send_message(message.author, msg)

async def my_background_task():
    await client.wait_until_ready()
    while not client.is_closed:
        try:
            sco = subprocess.check_output(['./topic.sh'], universal_newlines=True)
            await client.edit_channel(client.get_channel(id='390502114884845569'), topic=sco)
            await asyncio.sleep(10)
        except:
            pass

@client.event
async def on_ready():
    print('Logged in as')
    print(client.user.name)
    print(client.user.id)
    print('------')

client.loop.create_task(my_background_task())
client.run('MzUyNzI5ODI3NTU3NzY5MjE3.DIlYzw.Cw2gidQlz0VZlHTV_JQuXcaFfCA')
