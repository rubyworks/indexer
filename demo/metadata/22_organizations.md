## Indexer::Metadata#organizations

The `organizations` field holds a list of the company, club, foundation,
or programming groups involved with a project. For users of GitHub this
will most likey be the GitHub organization in which a project is hosted.

The Metadata class allows, of course, the canonical format.

    data = Indexer::Metadata.new

    data.organizations = [
      { 'name'  => 'Bobs Company',
        'email' => 'bob@mail.com',
        'roles' => ['sponsers']
      },
      { 'name'  => 'Johns Club',
        'email' => 'dlite@mail.com',
      }
    ]

But it also can handle and Array of Arrays. The order of the inner array
is `name, email, werbsite`. Only name is not optional.

    data.organizations = [
      ['Bobs Company', 'bob@mail.com'],
      ['Johns Club', 'dlite@mail.com', 'http://foo.org']
    ]

It will also handle an Array of strings, parsing out the given parts.

    data.organizations = [
      'Bobs Company <bob@mail.com>',
      'Johns Club <dlite@mail.com> http://foo.org'
    ]

It does this via recognition that an email address would be in `<...>`
brackets and URL validation for the website.

It can even handle combination of the above.

    data.organizations = [
      {'name'  => 'Bobs Company', 'email' => 'bob@mail.com'},
      ['Coco Chappel', '<coco@mail.com>'],
      ['Johns Club <dlite@mail.com>', 'http://foo.org']
    ]

    data.organizations[0].name.assert  == 'Bobs Company'
    data.organizations[0].email.assert == 'bob@mail.com'

    data.organizations[1].name.assert  == 'Coco Chappel'
    data.organizations[1].email.assert == 'coco@mail.com'

    data.organizations[2].name.assert    == 'Johns Club'
    data.organizations[2].email.assert   == 'dlite@mail.com'
    data.organizations[2].website.assert == 'http://foo.org'


