# Installation
1. `$ gem install dashing`
2. `$ gem install bundler`
3. `$ cd` (into repo)
4. `$ bundle`
5. `$ dashing start`

# Viewing a Dashboard
URL: `localhost:3030/nameofdashboard`

Drag widgets around to create new layouts once you are happy with a layout click the `Save this layout` button.

If your dashboard `.erb` already has a `<script>` tag at the top of the file just copy the line starting with `Dashing.gridsterLayout` and paste it within the function inside the `<script>` tag.

Otherwise copy and paste the code provided into your dashboard `.erb` file (starting on line 1)

# How stuff works
Things begin with the `/jobs` ruby files. These scripts will fetch data from whatever you define as the source. They will run however often you like as defined by `SCHEDULER.every '2m' do`. Anything after that line and before its `end` will run every `2m` (2 minutes). You could also use `2s` for 2 seconds. (at this time I am unsure if 2h would work for 2 hours)

Within the `SCHEDULER` there must be a `send_event` to send the data to a widget. For example, `send_event('github', { items: repo_issues.slice(0, 5) })` would send an event called `github` containing the array `repo_issues` sliced to the top 5 results only.

# Reference
[Dashing Website](http://shopify.github.com/dashing) for more information.